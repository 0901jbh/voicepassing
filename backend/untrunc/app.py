from flask import Flask,request, jsonify, make_response
from pydub import AudioSegment
import subprocess
import os

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
            DATA_PATH = os.environ.get("FLASK_DATA_PATH","/data/WebSocket")
            FLASK_FILE_PERIOD = int(os.environ.get("FLASK_FILE_PERIOD","10000"))
            FLASK_FILE_DUPLICATE = int(os.environ.get("FLASK_FILE_DUPLICATE","1000"))
            subprocess.run(["untrunc", f"{DATA_PATH}/ok.m4a", f"{DATA_PATH}/{session_id}/record.m4a"], check=True)
            subprocess.run(["mv", f"{DATA_PATH}/{session_id}/record.m4a_fixed.m4a", f"{DATA_PATH}/{session_id}/recover.m4a"], check=True)
            target = f"{DATA_PATH}/{session_id}/recover.m4a"
            partition_folder = f"{DATA_PATH}/{session_id}/part"
            audio_file = AudioSegment.from_file(target, format="m4a")
            window_size = FLASK_FILE_PERIOD
            cnt = 0

            new_file = []
            for i in range(0,len(audio_file),window_size):
                if not os.path.isfile(f"{partition_folder}/{cnt}.mp3"):
                    target = audio_file[i:i+window_size+FLASK_FILE_DUPLICATE]
                    if len(target)==(window_size+FLASK_FILE_DUPLICATE):
                        target.export(f"{partition_folder}/{cnt}.mp3", format="mp3")
                        new_file.append(f"{cnt}.mp3")
                cnt += 1

            return {"msg": True, "new_file": new_file }
        except subprocess.CalledProcessError:
            return make_response({"msg": "fail"}, 500)
    else:
        return make_response({"msg": "No session"}, 400)

if __name__ == '__main__':
    print("start_flask")
    app.run(host="0.0.0.0", port=8000)