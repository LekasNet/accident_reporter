<script>
  import './AdminPage.css'
  import DynamicSvg from "@/components/UI/Icon/DynamicSvg.vue";
  export default {
    name: 'AdminPage',
    components: {DynamicSvg},
    methods: {
      logout() {
        this.$router.push('/')
      },
    },
  };
</script>

<template>
  <header>
    <div class="header-wrapper">
      <DynamicSvg name="user" class="icon"/>
<!--      <router-link class="btn-logout" to="/" @click="logout">Logout</router-link>-->
      <button class="btn-logout" @click="logout">Выход</button>
    </div>
  </header>
  <main>
    <div class="main-wrapper">
      <div class="admin-menu">
        <nav class="menu-bar">
          <router-link class="menu-link" to="/admin/dtp">ДТП</router-link>
          <router-link class="menu-link" to="/admin/drivers">Водители</router-link>
          <router-link class="menu-link" to="/admin/vehicles">Транспорт</router-link>
        </nav>
      </div>
      <div class="main-content">
        <h1>Admin Page</h1>
        <p>Welcome, admin!</p>
      </div>
    </div>
  </main>
</template>
