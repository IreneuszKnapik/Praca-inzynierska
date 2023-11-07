package inz.model;


import javax.persistence.*;

@Entity
@Table(name="tasks")


public class Task {


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

    @Column(name = "description",columnDefinition = "TEXT")
    private String description;

    @Column(name = "answer",columnDefinition = "TEXT")
    private String answer;

    public String getCorrected_answer() {
        return corrected_answer;
    }

    public void setCorrected_answer(String corrected_answer) {
        this.corrected_answer = corrected_answer;
    }

    @Column(name = "corrected_answer",columnDefinition = "TEXT")
    private String corrected_answer;

    @Column(name = "user_id")
    private int user_id;

    public int getUser_id() {
        return user_id;
    }

    public void setUser_id(int user_id) {
        this.user_id = user_id;
    }


    public int getGraded() {
        return graded;
    }

    public void setGraded(int graded) {
        this.graded = graded;
    }

    @Column(name = "graded")
    private int graded;

    public int getTest_id() {
        return test_id;
    }

    public void setTest_id(int test_id) {
        this.test_id = test_id;
    }

    @Column(name = "test_id")
    private int test_id;




}
