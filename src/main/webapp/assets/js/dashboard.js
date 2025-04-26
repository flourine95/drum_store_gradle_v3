function logout() {
    Swal.fire({
        title: 'Xác nhận đăng xuất?',
        text: "Bạn có chắc chắn muốn đăng xuất khỏi hệ thống?",
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Đăng xuất',
        cancelButtonText: 'Hủy'
    }).then((result) => {
        if (result.isConfirmed) {
            document.getElementById('logoutForm').submit();
        }
    });
    return false;
} 