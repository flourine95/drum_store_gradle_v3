package com.drumstore.web.models;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Product {
    private int id;
    private String name;
    private String description;
    private double price;
    private int stock;
    private int totalViews;
    private boolean isFeatured;
    private int status;
    private double averageRating;
    private Timestamp createdAt;
    private List<ProductImage> images;
    private List<ProductColor> colors;
    private Category category;
    private Brand brand;
    private ProductSale productSale;
    private String imageMain;



    public String getImageMain() {
        return imageMain;
    }

    public void setImageMain(String imageMain) {
        this.imageMain = imageMain;
    }

    public Product() {
        this.images = new ArrayList<>();
        this.colors = new ArrayList<>();
    }

    public String getIsMainImage() {
        for (ProductImage image : images) {
            if (image.isIsMain()) {
                return image.getImage();
            }
        }
        return "";
    }

    public void addImage(ProductImage image) {
        this.images.add(image);
    }

    public void addColor(ProductColor color) {
        this.colors.add(color);
    }

    public String getImageIsMain() {
        for (ProductImage image : images) {
            if (image.isIsMain()) return image.getImage();
        }
        return "";
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public int getTotalViews() {
        return totalViews;
    }

    public List<ProductImage> getImages() {
        return images;
    }

    public List<ProductColor> getColors() {
        return colors;
    }

    public Category getCategory() {
        return category;
    }

    public Brand getBrand() {
        return brand;
    }

    public void setTotalViews(int totalViews) {
        this.totalViews = totalViews;
    }

    public boolean isIsFeatured() {
        return isFeatured;
    }

    public void setIsFeatured(boolean featured) {
        isFeatured = featured;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public double getAverageRating() {
        return averageRating;
    }

    public void setAverageRating(double averageRating) {
        this.averageRating = averageRating;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }


    public void setImages(List<ProductImage> images) {
        this.images = images;
    }

    public void setColors(List<ProductColor> colors) {
        this.colors = colors;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public void setBrand(Brand brand) {
        this.brand = brand;
    }

    public ProductImage getMainImage() {
        return images.stream().filter(ProductImage::isIsMain).findFirst().orElse(null);
    }

    public String getImage() {
        if (images != null && !images.isEmpty()) {
            return images.stream()
                    .filter(ProductImage::isIsMain)
                    .findFirst()
                    .map(ProductImage::getImage)
                    .orElse(images.getFirst().getImage());
        }
        return "product-default.jpg"; // ảnh mặc định nếu không có ảnh
    }

    public ProductSale getProductSale() {
        return productSale;
    }

    public void setProductSale(ProductSale productSale) {
        this.productSale = productSale;
    }

    public double getSalePrice() {
        if (productSale != null && productSale.getSale() != null) {
            return price * (1 - productSale.getSale().getDiscountPercentage() / 100);
        }
        return price;
    }

    @Override
    public String toString() {
        return "Product{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                ", price=" + price +
                ", stock=" + stock +
                ", totalViews=" + totalViews +
                ", isFeatured=" + isFeatured +
                ", status=" + status +
                ", averageRating=" + averageRating +
                ", createdAt=" + createdAt +
                ", images=" + images +
                ", colors=" + colors +
                ", category=" + category +
                ", brand=" + brand +
                ", productSale=" + productSale +
                '}';
    }


}