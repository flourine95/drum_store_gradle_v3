// Mảng lưu trữ danh sách địa chỉ
let addresses = [];

// Thêm các biến lưu trữ tên địa chỉ hành chính
let selectedProvinceName = '';
let selectedDistrictName = '';
let selectedWardName = '';

function previewImage(input) {
    if (input.files && input.files[0]) {
        // Kiểm tra kích thước file
        if (input.files[0].size > 10 * 1024 * 1024) { // 10MB
            alert('Kích thước file không được vượt quá 10MB');
            input.value = '';
            return;
        }

        // Kiểm tra loại file
        if (!input.files[0].type.startsWith('image/')) {
            alert('Vui lòng chọn file ảnh');
            input.value = '';
            return;
        }

        const reader = new FileReader();
        reader.onload = function(e) {
            document.getElementById('avatarPreview').src = e.target.result;
        }
        reader.readAsDataURL(input.files[0]);
    }
}

// Hàm load tỉnh/thành phố
function loadProvinces() {
    fetch('/location?action=provinces')
        .then(response => response.json())
        .then(data => {
            const provinceSelect = document.getElementById('newProvinceId');
            provinceSelect.innerHTML = '<option value="">Chọn tỉnh/thành phố</option>';
            data.forEach(province => {
                provinceSelect.innerHTML += `<option value="${province.id}">${province.name}</option>`;
            });
        });
}

// Hàm load quận/huyện
function loadDistricts(provinceId) {
    if (!provinceId) return;
    fetch(`/location?action=districts&provinceId=${provinceId}`)
        .then(response => response.json())
        .then(data => {
            const districtSelect = document.getElementById('newDistrictId');
            districtSelect.innerHTML = '<option value="">Chọn quận/huyện</option>';
            data.forEach(district => {
                districtSelect.innerHTML += `<option value="${district.id}">${district.name}</option>`;
            });
            // Reset phường/xã
            document.getElementById('newWardId').innerHTML = '<option value="">Chọn phường/xã</option>';
        });
}

// Hàm load phường/xã
function loadWards(districtId) {
    if (!districtId) return;
    fetch(`/location?action=wards&districtId=${districtId}`)
        .then(response => response.json())
        .then(data => {
            const wardSelect = document.getElementById('newWardId');
            wardSelect.innerHTML = '<option value="">Chọn phường/xã</option>';
            data.forEach(ward => {
                wardSelect.innerHTML += `<option value="${ward.id}">${ward.name}</option>`;
            });
        });
}

function addNewAddress() {
    const addressInput = document.getElementById('newAddress');
    const phoneInput = document.getElementById('newPhone');
    const isDefaultInput = document.getElementById('newIsDefault');
    const provinceSelect = document.getElementById('newProvinceId');
    const districtSelect = document.getElementById('newDistrictId');
    const wardSelect = document.getElementById('newWardId');

    // Validation
    if (!addressInput.value.trim() || !phoneInput.value.trim() || 
        !provinceSelect.value || !districtSelect.value || !wardSelect.value) {
        alert('Vui lòng nhập đầy đủ thông tin địa chỉ');
        return;
    }

    // Nếu đánh dấu là địa chỉ mặc định, bỏ đánh dấu các địa chỉ khác
    if (isDefaultInput.checked) {
        addresses.forEach(addr => addr.isDefault = false);
    }

    // Thêm địa chỉ mới vào mảng
    const newAddress = {
        address: addressInput.value.trim(),
        phone: phoneInput.value.trim(),
        provinceId: parseInt(provinceSelect.value),
        districtId: parseInt(districtSelect.value),
        wardId: parseInt(wardSelect.value),
        isDefault: isDefaultInput.checked
    };
    addresses.push(newAddress);

    // Cập nhật giao diện
    renderAddresses();

    // Reset form
    addressInput.value = '';
    phoneInput.value = '';
    provinceSelect.value = '';
    districtSelect.innerHTML = '<option value="">Chọn quận/huyện</option>';
    wardSelect.innerHTML = '<option value="">Chọn phường/xã</option>';
    isDefaultInput.checked = false;
}

function renderAddresses() {
    const container = document.getElementById('addressesContainer');
    container.innerHTML = '';

    addresses.forEach((addr, index) => {
        const addressElement = document.createElement('div');
        addressElement.className = 'list-group-item address-item';
        addressElement.innerHTML = `
            <div class="address-info">
                <strong>${addr.address}</strong> - ${addr.phone}<br>
                ${addr.isDefault ? '<span class="default-badge">Mặc định</span>' : ''}
            </div>
            <div class="address-actions">
                ${!addr.isDefault ? `
                    <button type="button" class="btn btn-sm btn-success"
                            onclick="setDefaultAddress(${index})">
                        Đặt mặc định
                    </button>
                ` : ''}
                <button type="button" class="btn btn-sm btn-danger"
                        onclick="removeAddress(${index})">
                    Xóa
                </button>
            </div>
        `;
        container.appendChild(addressElement);
    });

    document.getElementById('addressesJson').value = JSON.stringify(addresses);
}

function setDefaultAddress(index) {
    addresses.forEach(addr => addr.isDefault = false);
    addresses[index].isDefault = true;
    renderAddresses();
}

function removeAddress(index) {
    addresses.splice(index, 1);
    renderAddresses();
}

// Thêm event listeners khi document đã load
document.addEventListener('DOMContentLoaded', function() {
    // Load danh sách tỉnh/thành phố
    loadProvinces();

    // Thêm event listeners cho các select
    const provinceSelect = document.getElementById('newProvinceId');
    const districtSelect = document.getElementById('newDistrictId');

    provinceSelect.addEventListener('change', function() {
        loadDistricts(this.value);
    });

    districtSelect.addEventListener('change', function() {
        loadWards(this.value);
    });

    const form = document.getElementById('createUserForm');
    if (form) {
        form.addEventListener('submit', function(e) {
            if (addresses.length === 0) {
                e.preventDefault();
                alert('Vui lòng thêm ít nhất một địa chỉ');
                return;
            }

            // Kiểm tra có ít nhất một địa chỉ mặc định
            if (!addresses.some(addr => addr.isDefault)) {
                e.preventDefault();
                alert('Vui lòng chọn một địa chỉ mặc định');
                return;
            }
        });
    }
});


