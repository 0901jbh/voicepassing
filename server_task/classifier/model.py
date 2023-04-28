
# temporary model for test
class Model():
    def __init__(self):
        self.has_weight = False

    def set_weight(self):
        self.has_weight = True

    def forward(self, text):

        if self.has_weight:
            temp_result = {
                "result" : [0.1, 0.4, 0.3, 0.2],
                "attention" : {
                    "네" : [0.25],
                    "저는" : [0.2],
                    "금융" : [0.87],
                    "범죄" : [0.9],
                    "수사" : [0.88],
                    "1팀" : [0.84],
                    "의" : [0.1],
                    "김철민" : [0.247],
                    "수사관" : [0.99],
                    "이고" : [0.12],
                    "요" : [0.01],
                }
            }

            return temp_result

        else:
            return {"result" : [], "attention" : []}
        
model = Model()
