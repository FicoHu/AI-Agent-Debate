from flask import Flask, request, jsonify,Blueprint
import requests

debatefromnews = Blueprint('debatefromnews',__name__)

# 定义目标API的固定参数
API_URL = "https://maas-cn-southwest-2.modelarts-maas.com/v1/infers/8a062fd4-7367-4ab4-a936-5eeb8fb821c4/v1/chat/completions"
HEADERS = {
    "Content-Type": "application/json",
    "Authorization": "Bearer YOVu9vLFu3JG5Pl7ruiHud2trqaUNHojAcJVMFcfSUmOhBIJEMWW5Dui9oB1LIImZFSS2tszw51jTDBoqO8Ppg"
}

@debatefromnews.route('/api/generate_debate', methods=['GET'])
def generate_debate():
    # 获取URL参数
    target_url = request.args.get('url')
    if not target_url:
        return jsonify({"error": "Missing URL parameter"}), 400

    try:
        # 设置请求头，模拟浏览器访问
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        }
        # 获取目标网页内容
        response = requests.get(target_url, headers=headers)
        response.raise_for_status()
        # 自动处理编码（根据网页内容自适应）
        response.encoding = response.apparent_encoding
        html_content = response.text
    except requests.exceptions.RequestException as e:
        return jsonify({"error": f"Failed to fetch URL: {str(e)}"}), 500

    try:
        # 构造请求数据
        payload = {
            "model": "DeepSeek-R1",
            "messages": [
                {
                    "role": "user",
                    "content": f"网页HTML内容：\n{html_content}\n请根据这个网页内容生成三个辩论赛主题,输出结果按照这样结构输出<topic>话题1</topic> <topic>话题2</topic> <topic>话题3</topic>"
                }
            ],
            "stream": False,
            "temperature": 0.6
        }

        # 调用目标API
        api_response = requests.post(API_URL, headers=HEADERS, json=payload)
        api_response.raise_for_status()
        return jsonify(api_response.json())
    except requests.exceptions.RequestException as e:
        return jsonify({"error": f"API request failed: {str(e)}"}), 500
    except ValueError:
        return jsonify({"error": "Invalid response from API"}), 500
