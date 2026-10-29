package kz.kanatbeknurdos.studentapi;

public class StudentNotFoundException extends RuntimeException {
    public StudentNotFoundException(Long id) {
        super("Student with ID " + id + " was not found");
    }
}
