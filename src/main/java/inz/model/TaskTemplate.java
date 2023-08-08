package inz.model;

import org.hibernate.annotations.Type;

import javax.persistence.*;

@Entity
@Table(name="tasktemplates")


public class TaskTemplate {


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "score")
    private int score;

    @Column(name = "description")
    @Type(type = "text")
    private String description;

    @Type(type = "text")
    @Column(name = "answer")
    private String answer;



}