from flask import Flask,request, jsonify

import subprocess
app = Flask(__name__)
@app.route('/alive', methods=['GET'])
def aliveTest():
    return {"msg": "ALIVE"}


@app.route('/recover', methods=['GET'])
def recoverM4A():
    params = request.args.to_dict()
    session_id = params["sessionId"]
    
    if session_id:
        try:
            subprocess.run(["untrunc", f"/data/ok.m4a", f"/data/{session_id}/record.m4a"], check=True)
            subprocess.run(["mv", f"/data/{session_id}/record.m4a_fixed.m4a", f"/data/{session_id}/recover.m4a"], check=True)
            return {"msg": "성공"}
        except subprocess.CalledProcessError:
            return {"msg": "실패"}
    else:
        return {"msg": "세션없음"}

if __name__ == '__main__':
    print("start_flask")
    app.run(host="0.0.0.0", port=8000)