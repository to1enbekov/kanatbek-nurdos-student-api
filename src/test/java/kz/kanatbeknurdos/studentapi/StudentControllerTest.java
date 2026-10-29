package kz.kanatbeknurdos.studentapi;

import static org.hamcrest.Matchers.containsString;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import java.util.List;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

@WebMvcTest(StudentController.class)
class StudentControllerTest {
    @Autowired MockMvc mvc;
    @MockitoBean StudentService service;

    @Test
    void infoContainsMyName() throws Exception {
        mvc.perform(get("/api/info"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.student").value("Kanatbek Nurdos"));
    }

    @Test
    void listReturnsSuccess() throws Exception {
        when(service.findAll()).thenReturn(List.of(new Student("Kanatbek Nurdos", "nurdos@example.com", "DevOps")));
        mvc.perform(get("/api/students"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$[0].fullName").value("Kanatbek Nurdos"));
    }

    @Test
    void nonexistentStudentReturns404() throws Exception {
        when(service.findById(999L)).thenThrow(new StudentNotFoundException(999L));
        mvc.perform(get("/api/students/999"))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.message").value(containsString("999")));
    }

    @Test
    void invalidInputReturns400() throws Exception {
        mvc.perform(post("/api/students").contentType(MediaType.APPLICATION_JSON)
                .content("{\"fullName\":\"\",\"email\":\"not-an-email\",\"course\":\"\"}"))
            .andExpect(status().isBadRequest());
    }

    @Test
    void updateReturnsSuccess() throws Exception {
        when(service.update(eq(1L), any(StudentRequest.class)))
            .thenReturn(new Student("Kanatbek Nurdos", "nurdos@example.com", "CI/CD"));
        mvc.perform(put("/api/students/1").contentType(MediaType.APPLICATION_JSON)
                .content("{\"fullName\":\"Kanatbek Nurdos\",\"email\":\"nurdos@example.com\",\"course\":\"CI/CD\"}"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.course").value("CI/CD"));
    }
}
