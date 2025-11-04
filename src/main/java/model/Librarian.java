package model;

public class Librarian extends Staff {
    private int id;

    public Librarian() {
        super();
        setRole("LIBRARIAN");
    }

    public Librarian(int id, Staff staff) {
        super(staff.getId(), staff);
        this.id = id;
    }

    @Override
    public int getId() {
        return id;
    }

    @Override
    public void setId(int id) {
        this.id = id;
    }
}
