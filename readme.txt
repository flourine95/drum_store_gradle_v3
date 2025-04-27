Công việc | Lệnh
Xem danh sách container đang chạy | docker ps
Xem tất cả container (kể cả đã dừng) | docker ps -a
Xem danh sách image | docker images
Xóa container (theo id hoặc tên) | docker rm <container_id hoặc container_name>
Xóa nhiều container một lúc | docker rm $(docker ps -a -q)
Xóa image | docker rmi <image_id>
Xóa tất cả image | docker rmi $(docker images -q)
Xóa volume | docker volume rm <volume_name>
Xóa network | docker network rm <network_name>
Dọn dẹp toàn bộ (containers, images, volumes, networks không dùng) | docker system prune


Công việc | Lệnh
Vào bên trong container | docker exec -it <container_id hoặc container_name> /bin/bash(hoặc /bin/sh nếu bash không có)
Xem logs container | docker logs <container_id>
Theo dõi logs realtime | docker logs -f <container_id>
Restart container | docker restart <container_id>
Stop container | docker stop <container_id>
Start container | docker start <container_id>
Copy file từ máy host vào container | docker cp <đường_dẫn_host> <container_id>:<đường_dẫn_container>
Copy file từ container ra host | docker cp <container_id>:<đường_dẫn_container> <đường_dẫn_host>


📄 Các bước chỉnh /etc/ssh/sshd_config để root login
Mở file cấu hình sshd:

bash
Sao chép
Chỉnh sửa
vi /etc/ssh/sshd_config
hoặc nếu vi không có thì dùng:

bash
Sao chép
Chỉnh sửa
nano /etc/ssh/sshd_config
Tìm dòng (ấn /PermitRootLogin rồi Enter để tìm nhanh):

bash
Sao chép
Chỉnh sửa
#PermitRootLogin prohibit-password
hoặc

bash
Sao chép
Chỉnh sửa
PermitRootLogin no
Sửa thành:

bash
Sao chép
Chỉnh sửa
PermitRootLogin yes
(bỏ dấu # nếu có và đổi no thành yes)

(Tùy chọn) Nếu cần cho phép đăng nhập bằng mật khẩu (nhiều server mặc định tắt), thì cũng sửa:

bash
Sao chép
Chỉnh sửa
PasswordAuthentication yes
Save file và khởi động lại sshd:

bash
Sao chép
Chỉnh sửa
systemctl restart sshd
hoặc

bash
Sao chép
Chỉnh sửa
service sshd restart
⚡ Lưu ý
Nếu dùng container, một số CentOS image không cài sẵn sshd đâu, bạn cần:

bash
Sao chép
Chỉnh sửa
yum install -y openssh-server
rồi mới bật dịch vụ sshd được.

Nếu chạy container CentOS mà cần mở cổng SSH ra ngoài thì khi docker run phải thêm -p 22:22.

Ví dụ:

bash
Sao chép
Chỉnh sửa
docker run -d -p 22:22 --name mycentos centos
✅ Checklist kiểm tra lại sau khi chỉnh:

Kiểm tra	Lệnh
Kiểm tra sshd đang chạy chưa	systemctl status sshd
Kiểm tra cổng 22 đã mở chưa	ss -tlnp hoặc netstat -tulnp
Thử SSH vào server/container	ssh root@<ip>