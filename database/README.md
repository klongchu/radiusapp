# FreeRADIUS PostgreSQL Database

PostgreSQL 17 image พร้อม FreeRADIUS schema มาตรฐาน ใช้เป็น service `database` ใน [../docker-compose.yml](../docker-compose.yml)

## การทำงาน

[Dockerfile](Dockerfile) copy [init.sql](init.sql) ไปที่ `/docker-entrypoint-initdb.d/` ของ official Postgres image ระบบจะรันไฟล์นี้ **ครั้งเดียว** ตอนสร้าง PostgreSQL data directory ใหม่

> แก้ [init.sql](init.sql) หลังมี volume `pgdata` แล้วจะไม่ถูกนำเข้าใหม่ ต้องลบ volume ก่อน ซึ่งจะลบข้อมูล DB ทั้งหมด

```bash
# ลบข้อมูลฐานข้อมูลทั้งหมด แล้วสร้าง/seed ใหม่
# destructive: หยุด stack และลบ named volumes

docker compose down -v
docker compose up --build database
```

## การเชื่อมต่อ

| จุดเชื่อมต่อ | ค่า |
|---|---|
| ภายใน Docker network | `database:5432` |
| จาก host | `localhost:5434` |
| Database / user / password | อ่านจาก `DB_NAME` / `DB_USER` / `DB_PASSWORD` ใน `.env` |

ตัวอย่าง:

```bash
# จาก host
psql "postgresql://${DB_USER}:${DB_PASSWORD}@localhost:5434/${DB_NAME}"

# จาก container
docker compose exec database psql -U "$DB_USER" -d "$DB_NAME"
```

## Tables

| Table | หน้าที่ |
|---|---|
| `nas` | NAS clients: IP/CIDR, shared secret, ชื่อ, type |
| `radcheck` | User check attributes เช่น `Cleartext-Password` |
| `radreply` | RADIUS reply attributes ราย user |
| `radgroupcheck` | Check attributes ราย group |
| `radgroupreply` | Reply attributes ราย group |
| `radusergroup` | ความสัมพันธ์ user ↔ group และ priority |
| `radacct` | Accounting/session records จาก NAS |
| `radpostauth` | Authentication log |
| `cui` | Chargeable-User-Identity records |

ทุก table หลักมี primary key และ sequence สำหรับสร้าง ID; [init.sql](init.sql) มี index สำหรับ user/group lookup และ active accounting sessions

## Seed data

schema seed:

- NAS catch-all: `0.0.0.0/0` พร้อม shared secret ใน [init.sql](init.sql)
- User ทดสอบ: `lfsegoro@github.com` / password `8888`

ข้อมูลนี้สำหรับ development เท่านั้น เปลี่ยน NAS secret และลบ test user ก่อน deploy production

## ดูแล schema

แก้ไข schema ที่ [init.sql](init.sql) แล้ว reinitialize database ตามขั้นตอนด้านบน หรือ apply migration ด้วย `psql` สำหรับ environment ที่มีข้อมูลอยู่แล้ว

ตรวจ table:

```bash
docker compose exec database psql -U "$DB_USER" -d "$DB_NAME" -c '\dt'
```

ดู active sessions:

```bash
docker compose exec database psql -U "$DB_USER" -d "$DB_NAME" \
  -c 'SELECT username, nasipaddress, acctstarttime FROM radacct WHERE acctstoptime IS NULL;'
```
