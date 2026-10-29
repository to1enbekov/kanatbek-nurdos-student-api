package kz.kanatbeknurdos.studentapi;

import java.util.List;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class StudentService {
    private final StudentRepository repository;

    public StudentService(StudentRepository repository) { this.repository = repository; }

    @Transactional(readOnly = true)
    public List<Student> findAll() { return repository.findAll(Sort.by("id")); }

    @Transactional(readOnly = true)
    public Student findById(Long id) {
        return repository.findById(id).orElseThrow(() -> new StudentNotFoundException(id));
    }

    @Transactional
    public Student create(StudentRequest request) {
        return repository.save(new Student(request.fullName(), request.email(), request.course()));
    }

    @Transactional
    public Student update(Long id, StudentRequest request) {
        Student student = findById(id);
        student.setFullName(request.fullName());
        student.setEmail(request.email());
        student.setCourse(request.course());
        return repository.save(student);
    }

    @Transactional
    public void delete(Long id) {
        Student student = findById(id);
        repository.delete(student);
    }
}
