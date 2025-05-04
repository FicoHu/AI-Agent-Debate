<template>
  <div class="debate-container">
    <!-- 辩论主题 -->
    <div class="debate-header">
      <h1 class="debate-title">辩论主题</h1>
      <div class="debate-topic">{{ debateInfo.topic.title }}</div>
      
      <div class="teams-info">
        <div class="team blue-team">
          <div class="team-name">蓝队</div>
          <div class="team-stance">
            <span class="stance-label"><i class="stance-icon">&#9733;</i></span>
            <span class="stance-value">{{ debateInfo.blueStance }}</span>
          </div>
          <div class="player-type">选手: {{ debateInfo.bluePlayerType }}</div>
        </div>
        
        <div class="team red-team">
          <div class="team-name">红队</div>
          <div class="team-stance">
            <span class="stance-label"><i class="stance-icon">&#9733;</i></span>
            <span class="stance-value">{{ debateInfo.redStance }}</span>
          </div>
          <div class="player-type">选手: {{ debateInfo.redPlayerType }}</div>
        </div>
      </div>
      
     
    </div>
    
    <!-- 辩论内容 -->
    <div class="debate-content">
      <div class="debate-status">辩论中</div>
      
      <div class="chat-container">
        <!-- 动态显示辩论内容 -->
        <template v-for="(message, index) in messages.slice(0, currentRound)" :key="index">
          <!-- 蓝队消息 -->
          <div class="chat-message blue-message" v-if="message.type === 'blue'" v-show="message.displayContent.length > 0">
            <div class="avatar blue-avatar">蓝</div>
            <div class="message-content">
              <div class="message-bubble">
                {{ message.displayContent }}
              </div>
            </div>
          </div>
          
          <!-- 红队消息 -->
          <div class="chat-message red-message" v-if="message.type === 'red'" v-show="message.displayContent.length > 0">
            <div class="message-content">
              <div class="message-bubble">
                {{ message.displayContent }}
              </div>
            </div>
            <div class="avatar red-avatar">红</div>
          </div>
          
          <!-- 主持人消息 -->
          <div class="chat-message host-message" v-if="message.type === 'host'" v-show="message.displayContent.length > 0">
            <div class="avatar host-avatar">主</div>
            <div class="message-content host-content">
              <div class="message-bubble">
                {{ message.displayContent }}
              </div>
            </div>
          </div>
        </template>
      </div>
    </div>
    
    <!-- 底部操作栏 -->
    <div class="debate-footer">
      <button class="back-button" @click="goBack">返回</button>
      <button class="share-button" @click="shareDebate">分享</button>
    </div>
    
    <!-- 底部导航栏 -->
    <BottomNavBar activePage="debate" />
  </div>
</template>

<script>
import BottomNavBar from '../components/BottomNavBar.vue';

export default {
  name: 'DebateView',
  components: {
    BottomNavBar
  },
  data() {
    return {
      debateInfo: {
        topic: { id: 0, title: '结婚还是做单身狗', description: '' },
        selectedTeam: 'blue',
        blueStance: '结婚',
        redStance: '单身狗',
        bluePlayerType: '保守型',
        redPlayerType: '激进型',
        useVoice: '是'
      },
      debateRounds: 15,
      currentRound: 4,
      messages: [
        {
          type: 'host',
          content: '各位观众朋友们大家好，欢迎来到本次辩论。今天的辩题是《结婚还是做单身狗》。蓝队将支持「结婚」，红队将支持「单身狗」。辩论共计15轮，现在开始第一轮辩论。',
          displayContent: '',
          isTyping: false,
          typingIndex: 0
        },
        {
          type: 'blue',
          content: '家庭温暖和经济稳定性: 结婚后可以享受家庭的温暖，有人陪伴和照顾，尤其是在遇到困难时有人分担。',
          displayContent: '',
          isTyping: false,
          typingIndex: 0
        },
        {
          type: 'red',
          content: '自由和独立: 单身生活最大的优点是自由，可以自由安排自己的时间和生活，无需考虑他人的感受和需求。经济上也更自由，可以随心所欲地花钱而不用担心另一半的意见',
          displayContent: '',
          isTyping: false,
          typingIndex: 0
        },
        {
          type: 'host',
          content: '第一轮辩论结束，双方观点鲜明。现在进入第二轮辩论，请双方针对对方观点进行深入辩论。',
          displayContent: '',
          isTyping: false,
          typingIndex: 0
        },
        {
          type: 'blue',
          content: '对于红队提到的自由问题，我认为婚姻并不会完全剪除个人自由。婚姻是两个人共同成长的过程，可以通过沟通和相互尊重来保持各自的空间和自由。',
          displayContent: '',
          isTyping: false,
          typingIndex: 0
        },
        {
          type: 'red',
          content: '蓝队提到的家庭温暖确实存在，但这种温暖也可以从朋友和家人关系中获得。而且，婚姻生活中的矛盾和压力可能会让这种温暖变成负担，单身生活可以避免这些问题。',
          displayContent: '',
          isTyping: false,
          typingIndex: 0
        }
      ],
      typingSpeed: 50, // 打字速度，毫秒/字符
      activeMessageIndex: 0 // 当前正在打字的消息索引
    }
  },
  created() {
    // 从本地存储获取辩论信息
    const savedDebateInfo = localStorage.getItem('debateInfo');
    if (savedDebateInfo) {
      this.debateInfo = JSON.parse(savedDebateInfo);
    }
    
    // 初始化辩论内容
    this.initializeDebate();
    
    // 启动打字机效果
    this.startTypingEffect();
  },
  methods: {
    initializeDebate() {
      // 如果没有保存的辩论信息，使用默认值
      if (!this.debateInfo) {
        this.debateInfo = {
          topic: { id: 0, title: '结婚还是做单身狗', description: '' },
          selectedTeam: 'blue',
          blueStance: '结婚',
          redStance: '单身狗',
          bluePlayerType: '保守型',
          redPlayerType: '激进型',
          useVoice: '是'
        };
      }
      
      // 确保消息数组被正确初始化
      if (!this.messages || this.messages.length === 0) {
        // 使用data中预定义的messages数组
        // 注意：这里不需要重新赋值，因为data中已经定义了默认值
      }
    },
    // 启动打字机效果
    startTypingEffect() {
      // 重置所有消息的显示状态
      this.messages.forEach(message => {
        message.displayContent = '';
        message.isTyping = false;
        message.typingIndex = 0;
      });
      
      // 开始第一条消息的打字效果
      this.activeMessageIndex = 0;
      this.typeNextMessage();
    },
    
    // 处理下一条消息的打字效果
    typeNextMessage() {
      // 如果所有消息都已经处理完毕，则返回
      if (this.activeMessageIndex >= Math.min(this.currentRound, this.messages.length)) {
        return;
      }
      
      // 获取当前消息
      const message = this.messages[this.activeMessageIndex];
      message.isTyping = true;
      
      // 开始打字效果
      this.typeMessage(message);
    },
    
    // 实现打字机效果
    typeMessage(message) {
      // 如果所有字符都已经显示完毕
      if (message.typingIndex >= message.content.length) {
        message.isTyping = false;
        
        // 延迟一段时间后显示下一条消息
        setTimeout(() => {
          this.activeMessageIndex++;
          this.typeNextMessage();
        }, 500);
        
        return;
      }
      
      // 每次添加一个字符
      message.displayContent += message.content.charAt(message.typingIndex);
      message.typingIndex++;
      
      // 设置下一个字符的延迟
      setTimeout(() => {
        this.typeMessage(message);
      }, this.typingSpeed);
    },
    
    goBack() {
      this.$router.go(-1);
    },
    shareDebate() {
      alert('分享功能即将上线');
    },
    navigateTo(path) {
      this.$router.push(path);
    }
  }
}
</script>

<style scoped>
.debate-container {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background-color: #f5f5f5;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
  padding-bottom: 60px; /* 为底部导航栏留出空间 */
}

/* 辩论头部样式 */
.debate-header {
  padding: 15px;
  background-color: white;
  border-bottom: 1px solid #f5f5f5;
  border-radius: 8px 8px 0 0;
  margin: 15px 15px 0;
}

.debate-title {
  font-size: 16px;
  font-weight: 500;
  color: #333;
  margin-bottom: 8px;
}

.debate-topic {
  font-size: 14px;
  line-height: 1.5;
  color: #666;
  margin-bottom: 12px;
  padding-bottom: 12px;
  border-bottom: 1px solid #f5f5f5;
}

.teams-info {
  display: flex;
  justify-content: space-between;
  margin-bottom: 12px;
}

.team {
  flex: 1;
  padding: 10px;
  border-radius: 8px;
  background-color: #f9f9f9;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.blue-team {
  background-color: rgba(74, 123, 255, 0.1);
  margin-right: 5px;
}

.red-team {
  background-color: rgba(255, 74, 74, 0.1);
  margin-left: 5px;
}

/* 辩论内容样式 */
.debate-content {
  flex: 1;
  padding: 15px;
  display: flex;
  flex-direction: column;
  margin: 0 15px;
}

.debate-status {
  background-color: white;
  padding: 10px;
  text-align: center;
  font-weight: 500;
  font-size: 14px;
  border-radius: 8px;
  margin-bottom: 12px;
  position: sticky;
  top: 0;
  z-index: 10;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.chat-container {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 15px;
  padding-bottom: 20px;
}

.chat-message {
  display: flex;
  margin-bottom: 15px;
  align-items: flex-start;
}

.blue-message {
  justify-content: flex-start;
}

.red-message {
  justify-content: flex-end;
}

.host-message {
  justify-content: flex-start;
  margin: 20px 0;
  position: relative;
}

.avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  font-weight: bold;
  color: white;
  flex-shrink: 0;
}

.blue-avatar {
  background-color: #4a7bff;
  margin-right: 10px;
}

.red-avatar {
  background-color: #ff4a4a;
  margin-left: 10px;
}

.host-avatar {
  background-color: #07c160;
  margin-right: 10px;
}

.message-content {
  max-width: 70%;
}

.host-content {
  margin: 0 auto;
  display: flex;
  justify-content: center;
  width: 100%;
}

.message-bubble {
  padding: 12px 15px;
  border-radius: 18px;
  font-size: 14px;
  line-height: 1.5;
  position: relative;
  word-break: break-word;
}

.blue-message .message-bubble {
  background-color: #4a7bff;
  color: white;
  border-bottom-left-radius: 5px;
}

.red-message .message-bubble {
  background-color: #ff4a4a;
  color: white;
  border-bottom-right-radius: 5px;
}

.host-message .message-bubble {
  background-color: #07c160;
  color: white;
  border-radius: 18px;
  max-width: 80%;
}

.message-time {
  font-size: 12px;
  color: #999;
  margin-top: 5px;
  text-align: right;
}

/* 底部操作栏样式 */
.debate-footer {
  display: flex;
  padding: 15px;
  background-color: white;
  border-top: 1px solid #f5f5f5;
  border-radius: 0 0 8px 8px;
  margin: 0 15px;
}

.back-button, .share-button {
  flex: 1;
  padding: 10px 0;
  border: none;
  border-radius: 8px;
  font-size: 14px;
  cursor: pointer;
}

.back-button {
  background-color: #f0f0f0;
  color: #333;
  margin-right: 10px;
}

.share-button {
  background-color: #07c160;
  color: white;
}

/* 底部导航栏样式 */
.footer {
  display: flex;
  justify-content: space-around;
  padding: 12px 0;
  background-color: white;
  border-top: 1px solid #eee;
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  z-index: 10;
}

.nav-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  font-size: 12px;
  cursor: pointer;
}

.nav-item .icon {
  font-size: 20px;
  margin-bottom: 4px;
}

.nav-item.active {
  color: #07c160;
}
</style>
