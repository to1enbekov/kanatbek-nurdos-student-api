package kz.kanatbeknurdos.studentapi;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

import java.util.Optional;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

class StudentServiceTest {
    private StudentRepository repository;
    private StudentService service;

    @BeforeEach
    void setup() {
        repository = mock(StudentRepository.class);
        service = new StudentService(repository);
    }

    @Test
    void createStudentWithMyName() {
        when(repository.save(any(Student.class))).thenAnswer(inv -> inv.getArgument(0));
        Student result = service.create(new StudentRequest("Kanatbek Nurdos", "nurdos@example.com", "DevOps"));
        assertEquals("Kanatbek Nurdos", result.getFullName());
        assertEquals("DevOps", result.getCourse());
        verify(repository).save(any(Student.class));
    }

    @Test
    void getByIdWhenMissingReturnsNotFoundException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());
        assertThrows(StudentNotFoundException.class, () -> service.findById(999L));
    }

    @Test
    void updateStudentChangesCourse() {
        Student existing = new Student("Kanatbek Nurdos", "nurdos@example.com", "DevOps");
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.save(existing)).thenReturn(existing);
        Student updated = service.update(1L, new StudentRequest("Kanatbek Nurdos", "nurdos@example.com", "Jenkins"));
        assertEquals("Jenkins", updated.getCourse());
        verify(repository).save(existing);
    }

    @Test
    void deleteStudentRemovesExistingRecord() {
        Student existing = new Student("Kanatbek Nurdos", "nurdos@example.com", "Docker");
        when(repository.findById(2L)).thenReturn(Optional.of(existing));
        service.delete(2L);
        verify(repository).delete(existing);
    }

    @Test
    void deleteMissingStudentThrowsNotFound() {
        when(repository.findById(20L)).thenReturn(Optional.empty());
        assertThrows(StudentNotFoundException.class, () -> service.delete(20L));
    }
}
