package kz.kanatbeknurdos.studentapi;

import java.net.URI;
import java.util.List;
import java.util.Map;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import jakarta.validation.Valid;

@RestController
@RequestMapping("/api")
public class StudentController {
    private final StudentService service;
    public StudentController(StudentService service) { this.service = service; }

    @GetMapping("/info")
    public Map<String, String> info() {
        return Map.of("student", "Kanatbek Nurdos", "application", "Student CRUD API", "version", "1.0.1");
    }

    @GetMapping("/students")
    public List<Student> list() { return service.findAll(); }

    @GetMapping("/students/{id}")
    public Student get(@PathVariable Long id) { return service.findById(id); }

    @PostMapping("/students")
    public ResponseEntity<Student> create(@Valid @RequestBody StudentRequest request) {
        Student created = service.create(request);
        return ResponseEntity.created(URI.create("/api/students/" + created.getId())).body(created);
    }

    @PutMapping("/students/{id}")
    public Student update(@PathVariable Long id, @Valid @RequestBody StudentRequest request) {
        return service.update(id, request);
    }

    @DeleteMapping("/students/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }
}
