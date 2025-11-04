package model;

public class Document {
    private int id;
    private String title;
    private String author;
    private String category;
    private int yearPublic;
    private String content;
    private String description;

    public Document() {
    }

    public Document(int id, String title, String author, String category, int yearPublic, String content, String description) {
        this.id = id;
        this.title = title;
        this.author = author;
        this.category = category;
        this.yearPublic = yearPublic;
        this.content = content;
        this.description = description;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public int getYearPublic() {
        return yearPublic;
    }

    public void setYearPublic(int yearPublic) {
        this.yearPublic = yearPublic;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
