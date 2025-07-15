package com.example.demo;

import com.example.demo.controller.EventController;
import com.example.demo.model.Event;
import com.example.demo.repository.EventRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(EventController.class)
public class EventControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private EventRepository eventRepository;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    public void getAllEvents_shouldReturnListOfEvents() throws Exception {
        Event event1 = new Event("Event 1", LocalDateTime.now(), "Description 1");
        Event event2 = new Event("Event 2", LocalDateTime.now(), "Description 2");

        when(eventRepository.findAll()).thenReturn(Arrays.asList(event1, event2));

        mockMvc.perform(get("/api/events"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.size()").value(2))
                .andExpect(jsonPath("$[0].title").value("Event 1"));
    }

    @Test
    public void createEvent_shouldReturnCreatedEvent() throws Exception {
        Event event = new Event("New Event", LocalDateTime.now(), "New Description");
        when(eventRepository.save(any(Event.class))).thenReturn(event);

        mockMvc.perform(post("/api/events")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(event)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.title").value("New Event"));
    }
}
