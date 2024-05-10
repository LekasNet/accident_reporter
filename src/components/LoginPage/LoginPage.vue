<template>
  <div>
    <h1>Login</h1>
    <form @submit.prevent="login">
      <label for="username">Username:</label>
      <input type="text" id="username" v-model="username" required />
      <br />
      <label for="password">Password:</label>
      <input type="password" id="password" v-model="password" required />
      <br />
      <button type="submit">
        <router-link to="/admin">Login</router-link>
      </button>
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
      };
    },
    methods: {
      login() {
        // Implement login logic here
      },
    },
  };
</script>