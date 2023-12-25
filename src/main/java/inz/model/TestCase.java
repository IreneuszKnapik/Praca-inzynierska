package inz.model;


import javax.persistence.*;

@Entity
@Table(name="testCases")


public class TestCase {


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "inputs",columnDefinition = "TEXT")
    private String inputs;

    public String getInputs() {
        return inputs;
    }

    public void setInputs(String inputs) {
        this.inputs = inputs;
    }

    public String getExpectedOutput() {
        return expectedOutput;
    }

    public void setExpectedOutput(String expectedOutput) {
        this.expectedOutput = expectedOutput;
    }

    public int getTasktemplate_id() {
        return tasktemplate_id;
    }

    public void setTasktemplate_id(int tasktemplate_id) {
        this.tasktemplate_id = tasktemplate_id;
    }

    @Column(name = "expectedOutput",columnDefinition = "TEXT")
    private String expectedOutput;

    @Column(name = "tasktemplate_id")
    private int tasktemplate_id;




}
