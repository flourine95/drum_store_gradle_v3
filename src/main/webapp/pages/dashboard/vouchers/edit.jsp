<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

<style>

    .voucher-container {
        min-height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
    }
    .voucher-edit-container {
        background-color: #fff;
        border-radius: 12px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        max-width: 900px; /* Tăng chiều rộng để chứa các trường ngang */
        width: 100%;
        padding: 30px;
        margin: 20px;
        border: 1px solid #e9ecef;
    }
    .voucher-edit-container h4 {
        color: #2c3e50;
        font-size: 1.8rem;
        font-weight: 700;
        margin-bottom: 25px;
        text-align: center;
        text-transform: uppercase;
        letter-spacing: 1px;
        border-bottom: 2px solid #1a73e8;
        padding-bottom: 10px;
    }
    .voucher-form {
        background: #f8f9fa;
        border-radius: 8px;
        padding: 25px;
    }
    .voucher-form h5 {
        color: #2c3e50;
        font-size: 1.3rem;
        font-weight: 600;
        margin-bottom: 20px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    .form-group {
        margin-bottom: 15px;
        display: flex;
        flex-direction: column;
        gap: 8px;
    }
    .form-row {
        display: flex;
        gap: 20px;
        margin-bottom: 15px;
    }
    .form-row .form-group {
        flex: 1;
        margin-bottom: 0;
    }
    .form-group label {
        font-weight: 600;
        color: #2c3e50;
        font-size: 1rem;
    }
    .form-group input,
    .form-group select,
    .form-group textarea {
        width: 100%;
        padding: 10px;
        border: 1px solid #ced4da;
        border-radius: 5px;
        font-size: 1rem;
        color: #34495e;
        transition: border-color 0.3s ease;
    }
    .form-group input:focus,
    .form-group select:focus,
    .form-group textarea:focus {
        border-color: #1a73e8;
        outline: none;
        box-shadow: 0 0 5px rgba(26, 115, 232, 0.3);
    }
    .form-group textarea {
        resize: vertical;
        min-height: 80px;
    }
    .form-actions {
        display: flex;
        justify-content: flex-end;
        gap: 10px;
        margin-top: 20px;
    }
    .btn {
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        font-size: 1rem;
        font-weight: 600;
        cursor: pointer;
        transition: background 0.3s ease;
    }
    .btn-primary {
        background: #1a73e8;
        color: #fff;
    }
    .btn-primary:hover {
        background: #1557b0;
    }
    .btn-secondary {
        background: #6c757d;
        color: #fff;
    }
    .btn-secondary:hover {
        background: #5a6268;
    }
    .error-message {
        color: #dc3545;
        font-size: 0.9rem;
        margin-top: 5px;
        display: none;
    }
    /* Tùy chỉnh giao diện flatpickr */
    .flatpickr-calendar {
        font-family: 'Roboto', sans-serif;
        border: 1px solid #ced4da;
        border-radius: 8px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
    }
    .flatpickr-day.selected,
    .flatpickr-day.startRange,
    .flatpickr-day.endRange,
    .flatpickr-day.selected.inRange,
    .flatpickr-day.startRange.inRange,
    .flatpickr-day.endRange.inRange,
    .flatpickr-day.selected:focus,
    .flatpickr-day.startRange:focus,
    .flatpickr-day.endRange:focus,
    .flatpickr-day.selected:hover,
    .flatpickr-day.startRange:hover,
    .flatpickr-day.endRange:hover {
        background: #1a73e8;
        border-color: #1a73e8;
        color: #fff;
    }
    .flatpickr-day.today {
        border-color: #1a73e8;
        color: #1a73e8;
        font-weight: 600;
    }
    .flatpickr-day.today:hover {
        background: #e9ecef;
    }
    .flatpickr-monthDropdown-months,
    .flatpickr-year {
        font-size: 1rem;
        color: #2c3e50;
        font-weight: 600;
    }
    .flatpickr-weekdays {
        font-weight: 600;
        color: #34495e;
    }
    .flatpickr-current-month .numInputWrapper {
        font-size: 1rem;
    }
    .flatpickr-time input {
        font-size: 1rem;
        color: #34495e;
    }
    .flatpickr-time .numInputWrapper {
        border: 1px solid #ced4da;
        border-radius: 5px;
    }
    .flatpickr-time .arrowUp, .flatpickr-time .arrowDown {
        border-color: #1a73e8;
    }
    @media (max-width: 768px) {
        .voucher-edit-container {
            padding: 20px;
        }
        .voucher-form {
            padding: 15px;
        }
        .voucher-edit-container h4 {
            font-size: 1.5rem;
        }
        .voucher-form h5 {
            font-size: 1.1rem;
        }
        .form-row {
            flex-direction: column;
            gap: 15px;
        }
        .form-group label,
        .form-group input,
        .form-group select,
        .form-group textarea {
            font-size: 0.9rem;
        }
        .form-actions {
            flex-direction: column;
            gap: 8px;
        }
        .btn {
            width: 100%;
            padding: 12px;
        }
    }
</style>

<div class="voucher-container">
    <div class="voucher-edit-container">
        <h4>Chỉnh sửa Voucher</h4>
        <!-- Form chỉnh sửa voucher -->
        <div class="voucher-form">
            <h5>Thông tin Voucher</h5>
            <form id="voucherEditForm">
                <div class="form-group">
                    <label for="code">Mã voucher:</label>
                    <input type="text" id="code" name="code" value="${voucher.code}" required>
                    <div class="error-message" id="code-error">Mã voucher không được để trống.</div>
                </div>
                <div class="form-group">
                    <label for="description">Mô tả:</label>
                    <textarea id="description" name="description">${voucher.description}</textarea>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="discountType">Loại giảm giá:</label>
                        <select id="discountType" name="discountType">
                            <option value="1" ${voucher.discountType == 1 ? 'selected' : ''}>FIXED</option>
                            <option value="2" ${voucher.discountType == 2 ? 'selected' : ''}>PERCENTAGE</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="discountValue">Giá trị giảm:</label>
                        <input type="number" id="discountValue" name="discountValue" value="${voucher.discountValue}" step="0.01" min="0" required>
                        <div class="error-message" id="discountValue-error">Giá trị giảm phải lớn hơn hoặc bằng 0 và không được để trống.</div>
                    </div>
                </div>
                <div class="form-group">
                    <label for="minOrderValue">Giá trị đơn hàng tối thiểu:</label>
                    <input type="number" id="minOrderValue" name="minOrderValue" value="${voucher.minOrderValue}" step="0.01" min="0" required>
                    <div class="error-message" id="minOrderValue-error">Giá trị đơn hàng tối thiểu phải lớn hơn hoặc bằng 0 và không được để trống.</div>
                </div>
                <div class="form-group">
                    <label for="maxDiscountValue">Giảm giá tối đa:</label>
                    <input type="number" id="maxDiscountValue" name="maxDiscountValue" value="${voucher.maxDiscountValue}" step="0.01" min="0">
                    <div class="error-message" id="maxDiscountValue-error">Giảm giá tối đa phải lớn hơn hoặc bằng 0.</div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="startDate">Ngày bắt đầu:</label>
                        <input type="text" id="startDate" name="startDate" value="${voucher.startDate}" class="flatpickr" required>
                        <div class="error-message" id="startDate-error">Ngày bắt đầu không được để trống và phải nhỏ hơn ngày kết thúc.</div>
                    </div>
                    <div class="form-group">
                        <label for="endDate">Ngày kết thúc:</label>
                        <input type="text" id="endDate" name="endDate" value="${voucher.endDate}" class="flatpickr" required>
                        <div class="error-message" id="endDate-error">Ngày kết thúc không được để trống và phải lớn hơn ngày bắt đầu.</div>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="usageLimit">Giới hạn sử dụng:</label>
                        <input type="number" id="usageLimit" name="usageLimit" value="${voucher.usageLimit}" min="0">
                        <div class="error-message" id="usageLimit-error">Giới hạn sử dụng phải lớn hơn hoặc bằng 0.</div>
                    </div>
                    <div class="form-group">
                        <label for="perUserLimit">Giới hạn mỗi người dùng:</label>
                        <input type="number" id="perUserLimit" name="perUserLimit" value="${voucher.perUserLimit}" min="0">
                        <div class="error-message" id="perUserLimit-error">Giới hạn mỗi người dùng phải lớn hơn hoặc bằng 0.</div>
                    </div>
                </div>
                <div class="form-group">
                    <label for="status">Trạng thái:</label>
                    <select id="status" name="status">
                        <option value="0" ${voucher.status == 0 ? 'selected' : ''}>INACTIVE</option>
                        <option value="1" ${voucher.status == 1 ? 'selected' : ''}>ACTIVE</option>
                        <option value="2" ${voucher.status == 2 ? 'selected' : ''}>EXPIRED</option>
                    </select>
                </div>
                <div class="form-actions">
                    <button type="button" class="btn btn-secondary" onclick="window.history.back()">Hủy</button>
                    <button type="submit" class="btn btn-primary">Lưu</button>
                </div>
            </form>
        </div>
    </div>
</div>


<script>
    // Khởi tạo flatpickr cho các trường ngày giờ
    flatpickr(".flatpickr", {
        enableTime: true,
        dateFormat: "Y-m-d H:i",
        time_24hr: true,
        minuteIncrement: 1,
        defaultHour: 0,
        defaultMinute: 0,
        allowInput: true,
        onClose: function(selectedDates, dateStr, instance) {
            instance.element.value = dateStr;
        }
    });

    $(document).ready(function() {
        $('#voucherEditForm').on('submit', function(e) {
            e.preventDefault();
            if (validateForm()) {
                updateVoucher();
            }
        });
    });

    function validateForm() {
        let isValid = true;
        $('.error-message').hide();

        // Kiểm tra mã voucher
        const code = $('#code').val().trim();
        if (!code) {
            $('#code-error').show();
            isValid = false;
        }

        // Kiểm tra giá trị giảm
        const discountValue = parseFloat($('#discountValue').val());
        if (isNaN(discountValue) || discountValue < 0) {
            $('#discountValue-error').show();
            isValid = false;
        }

        // Kiểm tra giá trị đơn hàng tối thiểu
        const minOrderValue = parseFloat($('#minOrderValue').val());
        if (isNaN(minOrderValue) || minOrderValue < 0) {
            $('#minOrderValue-error').show();
            isValid = false;
        }

        // Kiểm tra giảm giá tối đa
        const maxDiscountValue = $('#maxDiscountValue').val();
        if (maxDiscountValue && (parseFloat(maxDiscountValue) < 0)) {
            $('#maxDiscountValue-error').show();
            isValid = false;
        }

        // Kiểm tra ngày bắt đầu và ngày kết thúc
        const startDate = $('#startDate').val();
        const endDate = $('#endDate').val();
        if (!startDate) {
            $('#startDate-error').text('Ngày bắt đầu không được để trống.').show();
            isValid = false;
        }
        if (!endDate) {
            $('#endDate-error').text('Ngày kết thúc không được để trống.').show();
            isValid = false;
        }
        if (startDate && endDate) {
            const start = new Date(startDate);
            const end = new Date(endDate);
            if (start >= end) {
                $('#startDate-error').text('Ngày bắt đầu phải nhỏ hơn ngày kết thúc.').show();
                $('#endDate-error').text('Ngày kết thúc phải lớn hơn ngày bắt đầu.').show();
                isValid = false;
            }
        }

        // Kiểm tra giới hạn sử dụng
        const usageLimit = $('#usageLimit').val();
        if (usageLimit && (parseInt(usageLimit) < 0)) {
            $('#usageLimit-error').show();
            isValid = false;
        }

        // Kiểm tra giới hạn mỗi người dùng
        const perUserLimit = $('#perUserLimit').val();
        if (perUserLimit && (parseInt(perUserLimit) < 0)) {
            $('#perUserLimit-error').show();
            isValid = false;
        }

        return isValid;
    }

    function updateVoucher() {
        const voucherData = {
            action: 'update',
            voucherId: ${voucher.id},
            code: $('#code').val().trim(),
            description: $('#description').val().trim(),
            discountType: parseInt($('#discountType').val()),
            discountValue: parseFloat($('#discountValue').val()),
            minOrderValue: parseFloat($('#minOrderValue').val()),
            maxDiscountValue: $('#maxDiscountValue').val() ? parseFloat($('#maxDiscountValue').val()) : null,
            startDate: $('#startDate').val(),
            endDate: $('#endDate').val(),
            usageLimit: $('#usageLimit').val() ? parseInt($('#usageLimit').val()) : null,
            perUserLimit: $('#perUserLimit').val() ? parseInt($('#perUserLimit').val()) : null,
            status: parseInt($('#status').val())
        };

        $.ajax({
            url: '${pageContext.request.contextPath}/dashboard/vouchers',
            type: 'POST',
            data: (voucherData),
            success: function(response) {
                if (response.status === 'success') {
                    Swal.fire({
                        icon: 'success',
                        title: 'Thành công',
                        text: response.message || 'Voucher đã được cập nhật thành công!',
                        timer: 1500,
                        showConfirmButton: false
                    });
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Thất bại',
                        text: response.message || 'Không thể cập nhật voucher.'
                    }).then(() => {
                        window.location.href = '${pageContext.request.contextPath}/dashboard/vouchers?action=edit&voucherId=${voucher.id}';
                    });
                }
            },
            error: function(xhr) {
                const errorMessage = xhr.responseJSON?.message || 'Đã xảy ra lỗi khi cập nhật voucher.';
                Swal.fire({
                    icon: 'error',
                    title: 'Lỗi',
                    text: errorMessage
                });
            }
        });
    }
</script>