<script>
  import './AdminPage.css'
  import AppFooter from "@/components/UI/Footer.vue";
  import DynamicSvg from "@/components/UI/Icon/DynamicSvg.vue";
  export default {
    name: 'AdminPage',
    components: {AppFooter, DynamicSvg},
    data(){
      return{
        userName: '',
      };
    },
    methods: {
      logout() {
        this.$router.push('/')
      },
      async Admin() {
        try {
          const token = localStorage.getItem('token');
          console.log(token);

          const request = {
            method: 'GET',
            headers: {
              'Content-Type': 'application/json',
              'authorization': `${token}`,
            },
          };

          const response = await fetch('https://accident-reporter.onrender.com/policeDepartment/profile', request
          ).then(response => response.json());

          console.log(response.data);
          this.userName = response.data.full_name;
        }catch (error){
          console.error('Ошибка получения данных о пользователе:', error);
        }
      },
    },
    mounted() {
      this.Admin();
    }
  };
</script>

<template>
  <header>
    <div class="header-wrapper">
      <DynamicSvg name="user" class="icon"/>
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
        <h1>Страница администратора</h1>
        <p>Добро пожаловть, {{ userName }}!</p>
      </div>
    </div>
  </main>
  <AppFooter />
</template>
