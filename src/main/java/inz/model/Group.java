package inz.model;

import org.hibernate.annotations.Fetch;
import org.hibernate.annotations.FetchMode;

import javax.persistence.*;
import java.util.HashMap;
import java.util.Map;

@Entity
@Table(name="groups")

public class Group {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
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

    public Map<Integer, User> getUsers() {
        return users;
    }

    public void setUsers(Map<Integer, User> users) {
        this.users = users;
    }

    public void addUser(User user) {
        this.users.put(user.getId(),user);
        user.getGroups().put(this.getId(),this);
    }
    public void removeUser(User user) {
        this.users.remove(user.getId());
        user.getGroups().remove(this.getId());

    }

    @ManyToMany(cascade = { CascadeType.MERGE, CascadeType.PERSIST })
    @JoinTable(
            name = "User_Group",
            joinColumns = { @JoinColumn(name = "group_id") },
            inverseJoinColumns = { @JoinColumn(name = "user_id") }
    )
    @javax.persistence.MapKey(name = "id")
    @Fetch(FetchMode.JOIN)
    private Map<Integer,User> users = new HashMap<>();

    @Column(name = "name")
    private String name;


    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Column(name = "description",columnDefinition = "TEXT")
    private String description;




    public void addTestTemplate(TestTemplate testTemplate) {
        this.testTemplates.put(testTemplate.getId(),testTemplate);
        testTemplate.getGroups().put(this.getId(),this);
    }
    public void removeGroup(Group group) {
        this.testTemplates.remove(group.getId());
        group.getTestTemplates().remove(this.getId());

    }

    public Map<Integer, TestTemplate> getTestTemplates() {
        return testTemplates;
    }

    public void setTestTemplates(Map<Integer, TestTemplate> testTemplates) {
        this.testTemplates = testTemplates;
    }

    @ManyToMany(cascade = { CascadeType.MERGE, CascadeType.PERSIST })
    @JoinTable(
            name = "group_testtemplate",
            joinColumns = { @JoinColumn(name = "group_id") },
            inverseJoinColumns = { @JoinColumn(name = "testtemplate_id") }
    )
    @Fetch(FetchMode.JOIN)
    @javax.persistence.MapKey(name = "id")
    private Map<Integer,TestTemplate> testTemplates = new HashMap<Integer,TestTemplate>();
}
