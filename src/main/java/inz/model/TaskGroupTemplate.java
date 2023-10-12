package inz.model;

import javax.persistence.*;

@Entity
@Table(name="taskgrouptemplates")

public class TaskGroupTemplate {


    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

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


    @Column(name = "name")
    private String name;


}
