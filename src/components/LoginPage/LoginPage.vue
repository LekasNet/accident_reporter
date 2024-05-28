<template class="login-page">
  <div class="form-container">
    <form class="login-form" @submit.prevent="signin">
      <h1 class="login-title">Авторизация</h1>
      <div class="input-data">
        <label class="lable-title" for="login">Имя пользователя:</label>
        <input class="input-str" type="text" id="login" placeholder="Введите имя пользователя..." v-model="login" required/>
      </div>
      <br />
      <div class="input-data">
        <label class="lable-title" for="password">Пароль:</label>
        <input
            class="input-str"
            type="password"
            id="password"
            placeholder="Введите пароль..."
            v-model="password"
            required />
      </div>
      <br />
      <!--      <router-link class="btn-logout" type="submit" to="/admin">Login</router-link>-->
      <button class="btn-login" type="submit">Войти</button>
            <p v-if="error" class="error-message">{{ error }}</p>
    </form>
  </div>
</template>

<script>
import './LoginPage.css'
import router from "@/router";

export default {
  name: 'LoginPage',
  data() {
    return {
      login: '',
      password: '',
      error: '',
      token: '',
      retrieve: '',
    };
  },
  methods: {
    async signin() {
      try {
        console.log(this.login, this.password)
        const request = {
          method: 'POST',
          headers: {'Content-Type': 'application/json'},
          body: JSON.stringify({
            login: this.login,
            password: this.password,
          })
        };
        const response = await fetch('https://accident-reporter.onrender.com/policeDepartment/login', request
        ).then(response => response.json());
        this.token = await response.token;
        if (response.message === 'Invalid login credentials') {
          // alert('Не правильный логин или пароль')
          // return 'Invalid login credentials';
          this.error = 'Не правильный логин или пароль';
          return;
        }

        // Save token to localStorage
        localStorage.setItem('token', this.token);

        console.log(response);
        // console.log("Авторизация успешна")

        const request_bearer = {
          method: 'GET',
          headers: {
            'Content-Type': 'application/json',
            'authorization': `${this.token}`,
          },
        };
        const response_bearer = await fetch('https://accident-reporter.onrender.com/policeDepartment/profile', request_bearer
        ).then(response_bearer => response_bearer.json());
        this.retrieve = await response_bearer.data;
        console.log(this.retrieve);
        await router.push({path: '/admin'})
        console.log("Авторизация успешна")
      } catch (error) {
        console.error('Не удалось авторизоваться в: ', error);
        this.error = 'Ошибка авторизации'
      }
    },
  },
};
</script>