package inz.model;

import javax.persistence.*;
import java.util.HashSet;
import java.util.Set;

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

    @Column(name = "description",columnDefinition = "TEXT")
    private String description;

    @Column(name = "answer",columnDefinition = "TEXT")
    private String answer;

    public Set<TestTemplate> getTestTemplates() {
        return testTemplates;
    }

    public void setTestTemplates(Set<TestTemplate> testTemplates) {
        this.testTemplates = testTemplates;
    }

    @ManyToMany(cascade = { CascadeType.MERGE, CascadeType.PERSIST })
    @JoinTable(
            name = "testtemplates_tasktemplates",
            joinColumns = { @JoinColumn(name = "tasktemplate_id") },
            inverseJoinColumns = { @JoinColumn(name = "testtemplate_id") }
    )
    Set<TestTemplate> testTemplates = new HashSet<>();

    public void addTestTemplate(TestTemplate testTemplate) {
        this.testTemplates.add(testTemplate);
        testTemplate.getTasks().add(this);
    }

    @Override
    public String toString() {
        return "TaskTemplate{" +
                "id=" + id +
                ", score=" + score +
                ", description='" + description + '\'' +
                ", answer='" + answer + '\'' +
                ", testTemplates=" + testTemplates +
                '}';
    }

    public void removeTestTemplate(TestTemplate testTemplate) {
        this.testTemplates.remove(testTemplate);
        testTemplate.getTasks().remove(this);
    }




}
