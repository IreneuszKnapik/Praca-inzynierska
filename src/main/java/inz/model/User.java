package inz.model;


import org.hibernate.annotations.Fetch;
import org.hibernate.annotations.FetchMode;

import javax.persistence.*;
import java.util.HashMap;
import java.util.Map;

@Entity
@Table(name="users")
public class User {

    private static final long serialVersionUID = 1L;


    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "username")
    private String username;

    @Column(name = "password")
    private String password;

    @Column(name = "email")
    private String email;

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    @Column(name = "type")
    private Integer type;

    //0 is blocked user
    //1 is regular user - solves tests
    //2 is creator - also creates tests and sees answers
    //3 is admin - can access everything


    public Map<Integer, Group> getGroups() {
        return groups;
    }

    public void setGroups(Map<Integer, Group> groups) {
        this.groups = groups;
    }

    @ManyToMany(cascade = { CascadeType.MERGE, CascadeType.PERSIST })
    @JoinTable(
            name = "User_Group",
            joinColumns = { @JoinColumn(name = "user_id") },
            inverseJoinColumns = { @JoinColumn(name = "group_id") }
    )
    @javax.persistence.MapKey(name = "id")
    @Fetch(FetchMode.JOIN)
    private Map<Integer,Group> groups = new HashMap<>();

    public User() {

    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }



}
