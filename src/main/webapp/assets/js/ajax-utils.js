const AjaxUtils = {
    addToCart: function (productId, quantity, color, isQuickAdd = false) {
        // Nếu là thêm nhanh từ trang products thì gán màu mặc định
        if (isQuickAdd) {
            color = 'Default';  // Đổi thành chữ hoa đầu tiên
        }

        // Kiểm tra màu sắc
        if (!color) {
            Swal.fire({
                title: 'Lỗi!',
                text: 'Vui lòng chọn màu sắc',
                icon: 'warning'
            });
            return Promise.reject('Chưa chọn màu sắc');
        }

        // Kiểm tra số lượng hợp lệ
        if (quantity < 1) {
            Swal.fire({
                title: 'Lỗi!', text: 'Số lượng không hợp lệ', icon: 'warning'
            });
            return Promise.reject('Số lượng không hợp lệ');
        }

        return fetch('/cart/add', {
            method: 'POST', headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            }, body: `productId=${productId}&quantity=${quantity}&color=${color}`
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    this.updateCartCount(data.cartCount);

                    const Toast = Swal.mixin({
                        toast: true,
                        position: 'top-end',
                        showConfirmButton: false,
                        timer: 3000,
                        timerProgressBar: true,
                        didOpen: (toast) => {
                            toast.addEventListener('mouseenter', Swal.stopTimer)
                            toast.addEventListener('mouseleave', Swal.resumeTimer)
                        }
                    });

                    Toast.fire({
                        icon: 'success', title: data.message
                    });

                    return data;
                } else {
                    throw new Error(data.message || 'Có lỗi xảy ra');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                Swal.fire({
                    title: 'Lỗi!', text: error.message || 'Có lỗi xảy ra khi thêm vào giỏ hàng', icon: 'error'
                });
                throw error;
            });
    },

    removeFromCart: function (productId, color) {
        const Toast = Swal.mixin({
            toast: true, position: 'top-end', showConfirmButton: false, timer: 3000, timerProgressBar: true,
        });

        return Swal.fire({
            title: 'Xác nhận',
            text: 'Bạn có chắc muốn xóa sản phẩm này?',
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: 'Xóa',
            cancelButtonText: 'Hủy',
            confirmButtonColor: '#d33',
            cancelButtonColor: '#3085d6',
        }).then((result) => {
            if (result.isConfirmed) {
                return fetch('/cart/remove', {
                    method: 'POST', headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    }, body: `productId=${productId}&color=${color}`
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            // Cập nhật UI
                            this.updateCartCount(data.cartCount);
                            const cartItem = document.querySelector(`.cart-item[data-product-id="${productId}"][data-color="${color}"]`);
                            if (cartItem) {
                                cartItem.remove();
                            }

                            // Cập nhật tổng tiền
                            if (data.total !== undefined) {
                                this.updateCartTotal(data.total);
                            }

                            // Kiểm tra giỏ hàng trống
                            if (data.cartCount === 0) {
                                const cartContainer = document.querySelector('.cart-container');
                                if (cartContainer) {
                                    cartContainer.innerHTML = `
                                    <div class="text-center py-5">
                                        <h3>Giỏ hàng trống</h3>
                                        <a href="/products" class="btn btn-primary mt-3">
                                            Tiếp tục mua sắm
                                        </a>
                                    </div>
                                `;
                                }
                            }

                            Toast.fire({
                                icon: 'success', title: 'Đã xóa sản phẩm'
                            });
                        } else {
                            throw new Error(data.message || 'Có lỗi xảy ra');
                        }
                    });
            }
        });
    },

    updateCartItemColor: function (productId, oldColor, newColor) {
        if (!newColor) {
            Swal.fire({
                title: 'Lỗi!',
                text: 'Vui lòng chọn màu sắc mới',
                icon: 'warning'
            });
            return Promise.reject('Chưa chọn màu sắc mới');
        }

        // Không cho phép chọn lại Default
        if (newColor === 'Default') {
            Swal.fire({
                title: 'Lỗi!',
                text: 'Vui lòng chọn một màu sắc cụ thể',
                icon: 'warning'
            });
            // Reset select về màu cũ
            const colorSelect = document.querySelector(`.cart-item[data-product-id="${productId}"][data-color="${oldColor}"] select`);
            if (colorSelect) {
                colorSelect.value = oldColor;
            }
            return Promise.reject('Không thể chọn màu Default');
        }

        return fetch('/cart/update-color', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `productId=${productId}&oldColor=${oldColor}&newColor=${newColor}`
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                if (data.success) {
                    const cartItem = document.querySelector(`.cart-item[data-product-id="${productId}"][data-color="${oldColor}"]`);
                    if (cartItem) {
                        cartItem.setAttribute('data-color', newColor);

                        // Cập nhật data-color cho tất cả các phần tử liên quan
                        const quantityInput = cartItem.querySelector('input[type="text"]');
                        const colorSelect = cartItem.querySelector('select');
                        if (quantityInput) {
                            quantityInput.setAttribute('data-color', newColor);
                        }
                        if (colorSelect) {
                            colorSelect.value = newColor;
                        }

                        // Xóa thông báo warning nếu có
                        const warningText = cartItem.querySelector('small.text-danger');
                        if (warningText) {
                            warningText.remove();
                        }
                    }

                    const Toast = Swal.mixin({
                        toast: true,
                        position: 'top-end',
                        showConfirmButton: false,
                        timer: 3000,
                        timerProgressBar: true,
                    });

                    Toast.fire({
                        icon: 'success',
                        title: 'Đã cập nhật màu sắc'
                    });

                    return data;
                } else {
                    throw new Error(data.message || 'Có lỗi xảy ra');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                Swal.fire({
                    title: 'Lỗi!',
                    text: error.message || 'Có lỗi xảy ra khi cập nhật màu sắc',
                    icon: 'error'
                });
                throw error;
            });
    },

    updateCartCount: function (count) {
        let cartCountElement = document.querySelector('.cartCount');
        const cartIcon = document.querySelector('.btn-light.position-relative');

        if (count > 0) {
            if (!cartCountElement && cartIcon) {
                // Tạo mới badge nếu chưa có
                cartCountElement = document.createElement('span');
                cartCountElement.className = 'position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger cartCount';
                cartIcon.appendChild(cartCountElement);
            }
            if (cartCountElement) {
                cartCountElement.textContent = count;
                cartCountElement.style.display = 'block';
            }
        } else {
            // Ẩn badge nếu số lượng = 0
            if (cartCountElement) {
                cartCountElement.style.display = 'none';
            }
        }
    },

    updateCartTotal: function (total) {
        const cartTotalElement = document.querySelector('.cart-total');
        if (cartTotalElement) {
            cartTotalElement.textContent = new Intl.NumberFormat('vi-VN', {
                style: 'currency', currency: 'VND'
            }).format(total);
        }
    },

    updateCartItemQuantity: function (productId, color, quantity) {
        const quantityInput = document.querySelector(`input[data-product-id="${productId}"][data-color="${color}"]`);
        if (quantityInput) {
            quantityInput.value = quantity;

            // Cập nhật tổng tiền của item
            const priceElement = quantityInput.closest('.cart-item').querySelector('.item-price');
            const price = parseFloat(priceElement.getAttribute('data-price'));
            const totalElement = quantityInput.closest('.cart-item').querySelector('.item-total');
            if (totalElement) {
                const total = price * quantity;
                totalElement.textContent = new Intl.NumberFormat('vi-VN', {
                    style: 'currency', currency: 'VND'
                }).format(total);
            }
        }
    },
    updateQuantity: function (productId, color, newQuantity) {
        if (newQuantity < 1) {
            Swal.fire({
                title: 'Lỗi!',
                text: 'Số lượng không hợp lệ',
                icon: 'warning'
            });
            return Promise.reject('Số lượng không hợp lệ');
        }

        return fetch('/cart/update-quantity', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `productId=${productId}&color=${color}&quantity=${newQuantity}`
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Cập nhật số lượng trên UI
                    this.updateCartItemQuantity(productId, color, newQuantity);

                    // Cập nhật tổng tiền
                    if (data.total !== undefined) {
                        this.updateCartTotal(data.total);
                    }

                    return data;
                } else {
                    throw new Error(data.message || 'Có lỗi xảy ra');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                Swal.fire({
                    title: 'Lỗi!',
                    text: error.message || 'Có lỗi xảy ra khi cập nhật số lượng',
                    icon: 'error'
                });
                throw error;
            });
    },

    increaseQuantity: function (productId, color) {
        const quantityInput = document.querySelector(`input[data-product-id="${productId}"][data-color="${color}"]`);
        if (quantityInput) {
            const currentQuantity = parseInt(quantityInput.value);
            this.updateQuantity(productId, color, currentQuantity + 1);
        }
    },

    decreaseQuantity: function (productId, color) {
        const quantityInput = document.querySelector(`input[data-product-id="${productId}"][data-color="${color}"]`);
        if (quantityInput) {
            const currentQuantity = parseInt(quantityInput.value);
            if (currentQuantity > 1) {
                this.updateQuantity(productId, color, currentQuantity - 1);
            }
        }
    },

    // xử lí thêm xóa trong danh sách yêu thích
    toggleWishList(productId) {
        return   $.ajax({
            url: '/profile',
            method: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                action: 'toggle-wishList',
                data: productId
            }),
            success: function (response) {
                if (response.success) {
                    const icon = $('#addToWishlist i');

                    const Toast = Swal.mixin({
                        toast: true,
                        position: 'top-end',
                        showConfirmButton: false,
                        timer: 3000,
                        timerProgressBar: true,
                        didOpen: (toast) => {
                            toast.addEventListener('mouseenter', Swal.stopTimer);
                            toast.addEventListener('mouseleave', Swal.resumeTimer);
                        }
                    });

                    if (response.inWishlist) {
                        icon.removeClass('far').addClass('fas');
                        Toast.fire({
                            icon: 'success',
                            title: response.message || 'Đã thêm sản phẩm vào danh sách yêu thích!'
                        });
                    } else {
                        icon.removeClass('fas').addClass('far');
                        Toast.fire({
                            icon: 'info',
                            title: response.message || 'Đã xóa sản phẩm khỏi danh sách yêu thích!'
                        });
                    }
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Lỗi',
                        text: response.message || 'Có lỗi xảy ra, vui lòng thử lại!',
                    });
                }
            },
            error: function (xhr) {
                Swal.fire({
                    icon: 'error',
                    title: 'Lỗi',
                    text: 'Có lỗi xảy ra, vui lòng thử lại!',
                });
            }
        });
    }



}; 