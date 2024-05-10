// import Vue from 'vue';
import { createRouter, createWebHashHistory } from "vue-router";
import MainPage from "@/components/MainPage/MainPage.vue";
import LoginPage from "@/components/LoginPage/LoginPage.vue";
import AdminPage from "@/components/AdminPage/AdminPage.vue";
import DtpPage from "@/components/DtpPage/DtpPage.vue";


const routes = [
    {path: '/main', component: MainPage},
    {path: '/', component: LoginPage},
    {path: '/admin', component: AdminPage},
    {path: '/admin/dtp', component: DtpPage}
];

const router = createRouter({
    history: createWebHashHistory(),
    routes,
});

export default router;