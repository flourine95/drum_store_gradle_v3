document.addEventListener('DOMContentLoaded', function() {
    window.logout = function() {
        if (typeof Swal === 'undefined') {
            console.error('Swal is not defined');
            return false;
        }

        Swal.fire({
            title: 'Xác nhận đăng xuất?',
            text: "Bạn có chắc chắn muốn đăng xuất?",
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Đăng xuất',
            cancelButtonText: 'Hủy'
        }).then((result) => {
            console.log('Swal result:', result);
            if (result.isConfirmed) {
                const form = document.getElementById('logoutFormUser');
                if (form) {
                    form.submit();
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Lỗi',
                        text: 'Không tìm thấy biểu mẫu đăng xuất!',
                    });
                }
            }
        }).catch(error => {
            console.error('Swal error:', error);
        });

        return false;
    };
});
