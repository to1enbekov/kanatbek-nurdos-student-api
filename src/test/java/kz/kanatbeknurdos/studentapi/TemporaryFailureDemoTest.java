package kz.kanatbeknurdos.studentapi;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;
class TemporaryFailureDemoTest {
    @Test void intentionalFailure() { assertEquals(1, 1, "Deliberate CI failure demo"); }
}
