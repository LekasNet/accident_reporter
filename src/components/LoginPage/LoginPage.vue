<template>
  <div>
    <h1>Login</h1>
    <form @submit.prevent="login">
      <label for="username">Username:</label>
      <input type="text" id="username" v-model="username" required/>
      <br />
      <label for="password">Password:</label>
      <input
          :type="passwordType"
          id="password"
          v-model="password"
          required />
      <br />
<!--      <router-link class="btn-logout" type="submit" to="/admin">Login</router-link>-->
      <button class="btn-logout" type="submit">Войти</button>
    </form>
    <p v-if="error">{{ error }}</p>
  </div>
</template>

<script>
  export default {
    name: 'LoginPage',
    data() {
      return {
        username: '',
        password: '',
        error: '',
        passwordType: 'password',
      };
    },
    methods: {
      login() {
        this.$router.push('/admin');
      },
    },
  };
</script>