package com.drumstore.web.models;

public class ProductImage {
    private int id;
    private String image;
    private boolean isMain;
    private int productId;

    @Override
    public String toString() {
        return "ProductImage{" +
                "id=" + id +
                ", image='" + image + '\'' +
                ", isMain=" + isMain +
                ", productId=" + productId +
                '}';
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public boolean isIsMain() {
        return isMain;
    }

    public void setIsMain(boolean main) {
        isMain = main;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }


}
