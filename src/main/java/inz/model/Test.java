package inz.model;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name="tests")

public class Test {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Date getSubmit_date() {
        return submit_date;
    }

    public void setSubmit_date(Date submit_date) {
        this.submit_date = submit_date;
    }


    @Column(name = "submit_date")
    private Date submit_date;


    @Column(name = "start_date")
    private Date start_date;

    @JoinColumn(name = "user_id")
    private int user_id;

    public int getTest_template_id() {
        return test_template_id;
    }

    public void setTest_template_id(int test_template_id) {
        this.test_template_id = test_template_id;
    }

    @Column(name = "test_template_id")
    private int test_template_id;

    public Date getStart_date() {
        return start_date;
    }

    public void setStart_date(Date start_date) {
        this.start_date = start_date;
    }

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }



}
