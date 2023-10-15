package inz.model;

import javax.persistence.*;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name="testtemplates")

public class TestTemplate {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "due_date")
    private Date due_date;

    @Column(name = "name")
    private String name;

    @Column(name = "description")
    private String description;

    @JoinColumn(name = "allowed_attempts")
    private int allowed_attempts;


    public Set<User> getUsers() {
        return users;
    }

    public void setUsers(Set<User> users) {
        this.users = users;
    }

    @ManyToMany(mappedBy = "testTemplates")
    private Set<User> users = new HashSet<>();


    public Set<TaskTemplate> getTasks() {
        return tasks;
    }

    public void setTasks(Set<TaskTemplate> tasks) {
        this.tasks = tasks;
    }

    public void addTaskTemplate(TaskTemplate taskTemplate) {
        this.tasks.add(taskTemplate);
        taskTemplate.getTestTemplates().add(this);
    }
    public void removeTaskTemplate(TaskTemplate taskTemplate) {
        this.tasks.remove(taskTemplate);
        taskTemplate.getTestTemplates().remove(this);

    }

    @Override
    public String toString() {
        return "TestTemplate{" +
                "id=" + id +
                ", due_date=" + due_date +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                ", allowed_attempts=" + allowed_attempts +
                ", users=" + users +
                ", tasks=" + tasks.size() +
                '}';
    }


    @ManyToMany(cascade = { CascadeType.MERGE, CascadeType.PERSIST })
    @JoinTable(
            name = "testtemplates_tasktemplates",
            joinColumns = { @JoinColumn(name = "tasktemplate_id") },
            inverseJoinColumns = { @JoinColumn(name = "testtemplate_id") }
    )
    private Set<TaskTemplate> tasks = new HashSet<>();

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }





    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Date getDue_date() {
        return due_date;
    }

    public void setDue_date(Date due_date) {
        this.due_date = due_date;
    }

    public int getAllowed_attempts() {
        return allowed_attempts;
    }

    public void setAllowed_attempts(int allowed_attempts) {
        this.allowed_attempts = allowed_attempts;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }







}
