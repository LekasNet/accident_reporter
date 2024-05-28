import Vue from 'vue';
import Vuex from 'vuex';

Vue.use(Vuex);

export default new Vuex.Store({
    state: {
        token: localStorage.getItem('token') || '',
        // Другие свойства состояния
    },
    mutations: {
        setToken(state, token) {
            state.token = token;
        },
        // Другие мутации
    },
    actions: {
        setToken({ commit }, token) {
            commit('setToken', token);
        },
        getToken({ getters }) {
            return getters.getToken;
        },
        clearToken({ commit }) {
            commit('setToken', '');
        },
    },
    getters: {
        getToken: state => state.token,
        // Другие геттеры
    }
});