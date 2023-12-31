package inz.model;

import org.hibernate.annotations.Fetch;
import org.hibernate.annotations.FetchMode;

import javax.persistence.*;
import java.util.*;

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


    public Map<Integer,TaskTemplate> getTasks() {
        return tasks;
    }

    public void setTasks(HashMap<Integer,TaskTemplate> tasks) {
        this.tasks = tasks;
    }

    public void addTaskTemplate(TaskTemplate taskTemplate) {
        this.tasks.put(taskTemplate.getId(),taskTemplate);
        taskTemplate.getTestTemplates().add(this);
    }
    public void removeTaskTemplate(TaskTemplate taskTemplate) {
        this.tasks.remove(taskTemplate.getId());
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
                ", tasks=" + tasks.size() +
                '}';
    }


    @ManyToMany(cascade = { CascadeType.MERGE, CascadeType.PERSIST })
    @JoinTable(
            name = "testtemplates_tasktemplates",
            joinColumns = { @JoinColumn(name = "testtemplate_id") },
            inverseJoinColumns = { @JoinColumn(name = "tasktemplate_id") }
    )
    @Fetch(FetchMode.JOIN)
    @javax.persistence.MapKey(name = "id")
    private Map<Integer,TaskTemplate> tasks = new HashMap<Integer,TaskTemplate>();

    public Map<Integer, Group> getGroups() {
        return groups;
    }

    public void setGroups(Map<Integer, Group> groups) {
        this.groups = groups;
    }

    public void addGroup(Group group) {
        this.groups.put(group.getId(),group);
        group.getTestTemplates().put(this.getId(),this);
    }
    public void removeGroup(Group group) {
        this.groups.remove(group.getId());
        group.getTestTemplates().remove(this.getId());

    }

    @ManyToMany(cascade = { CascadeType.MERGE, CascadeType.PERSIST })
    @JoinTable(
            name = "group_testtemplate",
            joinColumns = { @JoinColumn(name = "testtemplate_id") },
            inverseJoinColumns = { @JoinColumn(name = "group_id") }
    )
    @Fetch(FetchMode.JOIN)
    @javax.persistence.MapKey(name = "id")
    private Map<Integer,Group> groups = new HashMap<Integer,Group>();



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
