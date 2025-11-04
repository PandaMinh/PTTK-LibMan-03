package model;

public class Staff extends User {
    private int id;

    public Staff() {
        super();
        setRole("STAFF");
    }

    public Staff(int id, User user) {
        super(user.getId(), user.getUsername(), user.getPassword(), user.getName(), 
              user.getTel(), user.getAddress(), user.getEmail(), user.getDateOfBirth(), user.getRole());
        this.id = id;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
}
