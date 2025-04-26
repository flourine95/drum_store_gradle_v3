package com.drumstore.web.models;

public class ProductColor {
    private int id;
    private String colorCode;
    private String colorName;
    private int productId;

    @Override
    public String toString() {
        return "ProductColor{" +
                "id=" + id +
                ", colorCode='" + colorCode + '\'' +
                ", colorName='" + colorName + '\'' +
                ", productId=" + productId +
                '}';
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getColorCode() {
        return colorCode;
    }

    public void setColorCode(String colorCode) {
        this.colorCode = colorCode;
    }

    public String getColorName() {
        return colorName;
    }

    public void setColorName(String colorName) {
        this.colorName = colorName;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }
}
