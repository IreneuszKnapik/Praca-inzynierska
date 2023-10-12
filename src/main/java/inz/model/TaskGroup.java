package inz.model;

import javax.persistence.*;

@Entity
@Table(name="taskgroup")

public class TaskGroup {


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

    public int getTesttemplate_id() {
        return testtemplate_id;
    }

    public void setTesttemplate_id(int testtemplate_id) {
        this.testtemplate_id = testtemplate_id;
    }

    @Column(name = "testtemplate_id")
    private int testtemplate_id;


}
