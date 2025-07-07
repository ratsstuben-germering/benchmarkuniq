from locust import HttpUser, task, between

class WebsiteUser(HttpUser):
    host = "http://localhost:5000"
    wait_time = between(0.1, 1)

    @task
    def index_page(self):
        self.client.get("/")
