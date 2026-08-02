# FreeRADIUS REST API (radapi)

REST API สำหรับจัดการข้อมูล FreeRADIUS (users, groups, NAS) บน Postgres backend สร้างด้วย FastAPI + Pydantic ใช้ repository pattern กับ raw parameterized SQL (ไม่มี ORM)

ในชุด docker-compose นี้ service ชื่อ `radapi` เข้าถึงได้ที่ <http://host-ip:8077> และดู API docs (Swagger UI) ได้ที่ `/docs`

## ออกแบบให้เรียบง่าย (KISS)

- รองรับเฉพาะ method `GET` / `POST` / `DELETE` เท่านั้น ไม่มี `PUT` / `PATCH`
- การแก้ไข object ให้ลบแล้วสร้างใหม่
- ทุก route ต้องแนบ header `X-API-Key: <API_KEY>` ทุกคำขอ

## การตั้งค่า (Environment variables)

ตั้งค่าผ่าน env var ได้ ค่า default เป็นค่าสำหรับ dev เท่านั้น — ดู [settings.py](settings.py)

| ตัวแปร | ความหมาย | ค่าเริ่มต้น |
|---|---|---|
| `API_KEY` | คีย์ที่ต้องแนบใน header `X-API-Key` (**บังคับ** ไม่มี default) | — |
| `DB_HOST` | host ของ Postgres | `172.16.220.16` |
| `DB_NAME` | ชื่อฐานข้อมูล | `radius` |
| `DB_USER` | username ของฐานข้อมูล | `root` |
| `DB_PASS` | password ของฐานข้อมูล | — |

ค่าอื่นที่ปรับได้ใน [settings.py](settings.py): `DB_DRIVER` (default `psycopg2` เปลี่ยนเป็น driver ตัวอื่นที่รองรับ PEP 249 ได้), ชื่อ table, `PER_PAGE` (จำนวนผลลัพธ์ต่อหน้า), `API_URL` (ใช้สร้าง header `Location` / `Link`)

## การรันด้วย Docker Compose

`radapi` รันอัตโนมัติพร้อมชุด compose ทั้งหมด (ดู [../docker-compose.yml](../docker-compose.yml)):

```bash
docker compose up radapi
```

โดยรับค่า `DB_HOST=database` และ `API_KEY` จาก `.env`

## การรันเฉพาะ API (local development)

ต้องมี Postgres ที่มี radius schema พร้อมใช้งาน เช่นสั่ง `docker compose up database`:

```bash
cd api
pip install -r requirements.txt

export DB_HOST=localhost DB_NAME=radius DB_USER=radius DB_PASS=1234
export API_KEY=changeme

uvicorn api:app --reload
```

เปิด <http://localhost:8000/docs> เพื่อดู Swagger UI

## Endpoints

ทุก endpoint ต้องแนบ header `X-API-Key`

| Method | Path | คำอธิบาย |
|---|---|---|
| GET | `/` | ข้อความต้อนรับ + ลิงก์ docs |
| GET | `/nas` | รายชื่อ NAS (pagination ด้วย `from_nasname`) |
| GET | `/nas/{nasname}` | ดูรายละเอียด NAS |
| POST | `/nas` | สร้าง NAS |
| DELETE | `/nas/{nasname}` | ลบ NAS |
| GET | `/users` | รายชื่อ users (pagination ด้วย `from_username`) |
| GET | `/users/{username}` | ดูรายละเอียด user |
| POST | `/users` | สร้าง user |
| DELETE | `/users/{username}` | ลบ user |
| GET | `/groups` | รายชื่อ groups (pagination ด้วย `from_groupname`) |
| GET | `/groups/{groupname}` | ดูรายละเอียด group |
| POST | `/groups` | สร้าง group |
| DELETE | `/groups/{groupname}` | ลบ group (`?ignore_users=true` เพื่อลบ group ที่ยังมี users) |

### ตัวอย่างการเรียก

```bash
# ดูรายชื่อ users
curl -H "X-API-Key: changeme" http://localhost:8000/users

# สร้าง user
curl -X POST http://localhost:8000/users \
  -H "X-API-Key: changeme" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "alice",
    "checks": [{"attribute": "Cleartext-Password", "op": ":=", "value": "s3cret"}]
  }'

# ลบ user
curl -X DELETE -H "X-API-Key: changeme" http://localhost:8000/users/alice
```

## กติกาทางธุรกิจ (Business rules)

- `User` / `Group` ต้องมี check หรือ reply attribute อย่างน้อยหนึ่งตัว หรือ (สำหรับ `User`) เป็นสมาชิกอย่างน้อยหนึ่ง group
- ไม่อนุญาตให้ผูก group/user ซ้ำภายใน object เดียวกัน (ตรวจที่ระดับ model)
- POST user/group ที่อ้างถึง group/user ที่ยังไม่มี → คืน `422` (ต้องสร้าง object ที่อ้างถึงก่อน)
- DELETE group ที่ยังมี users → คืน `422` เว้นแต่ระบุ `?ignore_users=true`
- Pagination เป็นแบบ cursor (`from_username` / `from_groupname` / `from_nasname`) ไม่ใช่ offset — cursor อยู่ใน response header `Link: rel="next"`

## โครงสร้างโค้ด

- [api.py](api.py) — FastAPI routes เท่านั้น (GET/POST/DELETE)
- [pyfreeradius/models.py](pyfreeradius/models.py) — Pydantic domain models (`User`, `Group`, `Nas`, `AttributeOpValue`, `UserGroup`, `GroupUser`) เป็น domain model แบบ UML ไม่ใช่ mapping 1:1 กับ table
- [pyfreeradius/repositories.py](pyfreeradius/repositories.py) — Repository pattern (`UserRepository`, `GroupRepository`, `NasRepository`) map ระหว่าง model กับ table `radcheck` / `radreply` / `radgroupcheck` / `radgroupreply` / `radusergroup` / `nas` ผ่าน raw parameterized SQL
- [dependencies.py](dependencies.py) — FastAPI DI: หนึ่ง DB session ต่อคำขอ, auto-commit เมื่อสำเร็จ / rollback เมื่อ error / ปิดเสมอ, และ verify API key
- [database.py](database.py) — import DB-API 2.0 driver ตามชื่อใน `settings.DB_DRIVER` แบบ dynamic
- [settings.py](settings.py) — ค่า config ทั้งหมด (override ผ่าน env var ได้)
- [sample.py](sample.py) — สคริปต์ตัวอย่างเรียกใช้ repository โดยตรง (ไม่ผ่าน HTTP) ใช้ตรวจ end-to-end กับ live DB ได้

## การทดสอบ

ต้องมี live DB ให้เชื่อมต่อ (test สร้าง/ลบ row จริง — ชี้ env var ไปที่ฐานข้อมูลชั่วคราวที่ทิ้งได้):

```bash
cd api
pytest tests/
pytest tests/test_pyfreeradius.py::test_valid_user   # รันเทสต์เดียว
```
