# radiusapp

ชุดแพ็กเกจพร้อมใช้งานทันที (OUT-OF-THE-BOX) โดยมี 3 services ใน docker-compose.yml:

1. freeradius server เป็น radius server
2. postgresql 17
3. radapi (FastAPI REST API พร้อม OpenAPI docs ที่ <http://host-ip:8077/docs>)

## ความต้องการของระบบ

1. การเชื่อมต่ออินเทอร์เน็ตของ mainhost
2. สภาพแวดล้อม *nix host ที่มีสิทธิ์ sudo หรือ root แนะนำ Fedora CoreOS (FCOS)
3. ติดตั้ง docker และ docker-compose แล้ว
4. ต้องติดตั้ง git

## วิธีใช้งาน

```bash
# เก็บชื่อ directory ไว้ในตัวแปร
project_name="radiusapp"
target_dir=$project_name # เปลี่ยนเป็นชื่อ directory อื่นได้ตามต้องการ

# เช็คว่ามี directory นี้อยู่แล้วหรือไม่ ถ้าไม่มีให้สร้างใหม่
if [ ! -d "$target_dir" ]; then
    mkdir -p "$target_dir"
    cd "$target_dir" || exit 1
    git clone https://github.com/klongchu/"$project_name".git .
else
    cd "$target_dir" || exit 1
    git pull # !!คำเตือน!! การทำแบบนี้จะเขียนทับเนื้อหาใน directory
fi

cp .env.example .env
# แก้ API_KEY ใน .env ก่อนใช้งานจริง

# ขั้นตอน build
docker compose build --no-cache
###################################################
# ถ้าทำขั้นตอนด้านบนแล้ว สามารถรันด้านล่างนี้ได้เลย
# โดยไม่ต้อง git clone และ build ใหม่อีกครั้ง

# ทางเลือกเสริม:
docker rm -f $(docker ps -aq -f status=exited) >/dev/null 2>&1 || true
docker network prune -f >/dev/null 2>&1 || true

docker compose up
true
```

ขั้นตอนถัดไป:

1. ปล่อยให้สคริปต์ทำการ pull และติดตั้งโดยอัตโนมัติ
2. เข้าใช้งานผ่าน API: <http://host-ip:8077/docs> (radapi OpenAPI docs)
3. ทดสอบด้วย Ntradping หรือทดสอบตรงจาก NAS เช่น mikrotik

รายละเอียดเพิ่มเติมสามารถดูได้ที่ docker-compose.yml หากต้องการดูรหัสผ่านหรือปรับแก้ค่าต่างๆ

ฐานข้อมูลมี username ตัวอย่างสำหรับทดสอบอยู่แล้ว สามารถเช็คได้ที่ตาราง radcheck

สามารถทดสอบด้วย ntradping หรือทดสอบตรงจาก NAS เช่น mikrotik

หากต้องการ:

- ปรับแต่งค่า config ของ freeradius เอง
- UI ที่สมบูรณ์ขึ้น

## รายละเอียดเพิ่มเติม

- username/password สำหรับทดสอบ มี 1 entry ในตาราง `radcheck`
- อนุญาตทุก host/nas โดยดู secret ได้ที่ 1 entry ในตาราง `nas`
- adminer สามารถเข้าถึงได้ทุกตาราง เลือก Postgresql, dbHost เป็น IP address, ส่วน username/password ดูได้ใน docker-compose.yml
- ความแตกต่างเดียวจาก freeradius config ค่าเริ่มต้น คือปรับแก้เฉพาะ module `sql` ใน `/etc/freeradius/mods-enable`
- ใช้ port หลายตัวทั้ง udp และ tcp ได้แก่ 1812, 1813, 3799, 5434, 8077 ถ้าทำเรื่องแบบนี้บ่อยๆ จะได้เรียนรู้เรื่อง backend, frontend และ tcp/ip เพิ่มขึ้นเยอะ
