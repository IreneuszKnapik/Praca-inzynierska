package inz.model;

import org.hibernate.annotations.Fetch;
import org.hibernate.annotations.FetchMode;

import javax.persistence.*;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

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

    @ManyToMany(mappedBy = "groups")
    private Set<User> users = new HashSet<>();

    @Column(name = "name")
    private String name;

    public Set<User> getUsers() {
        return users;
    }

    public void setUsers(Set<User> users) {
        this.users = users;
    }

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
