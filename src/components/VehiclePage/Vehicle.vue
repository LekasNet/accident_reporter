<script>
import './VehiclePage.css';
export default {
  name: 'VehiclePage',
  data() {
    return {
      vehicles: [],
    };
  },
  methods: {
    back() {
      this.$router.push('/admin');
    },
    async getDrivers() {
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
        const response = await fetch('https://accident-reporter.onrender.com/policeDepartment/vehicles', request);
        const jsonResponse = await response.json();
        console.log(jsonResponse.data);
        if (Array.isArray(jsonResponse.data)) {
          this.vehicles = jsonResponse.data;
          this.updateTable(this.vehicles);
        } else {
          console.error('Ошибка: сервер не возвращает массив данных');
        }
      } catch (error) {
        console.error('Ошибка получения данных о транспорте:', error);
      }
    },
    updateTable(data) {
      const table = document.getElementById('drTable');
      const tbody = table.querySelector('tbody');
      tbody.innerHTML = '';

      data.forEach(vehicle => {
        const row = document.createElement('tr');
        const marckCell = document.createElement('td');
        marckCell.textContent = vehicle.brand;
        const modelCell = document.createElement('td');
        modelCell.textContent = vehicle.model;
        const typeCell = document.createElement('td');
        typeCell.textContent = vehicle.body_type;
        const numbCell = document.createElement('td');
        numbCell.textContent = vehicle.reg_number;

        row.appendChild(marckCell);
        row.appendChild(modelCell);
        row.appendChild(typeCell);
        row.appendChild(numbCell);
        tbody.appendChild(row);
      });
    }
  },
  mounted() {
    this.getDrivers();

    const sortSelect = document.getElementById('sort-select');
    sortSelect.addEventListener('change', function() {
      const selectedValue = sortSelect.value;
      let sortedData = [];
      if (selectedValue === 'accidents-asc') {
        sortedData = this.drivers.sort((a, b) => a.accidents - b.accidents);
        // } else if (selectedValue === 'accidents-desc') {
        //   sortedData = this.drivers.sort((a, b) => b.accidents - a.accidents);
        // } else if (selectedValue === 'id-asc') {
        //   sortedData = this.drivers.sort((a, b) => a.id - b.id);
        // } else if (selectedValue === 'name-asc') {
        //   sortedData = this.drivers.sort((a, b) => a.full_name.localeCompare(b.full_name));
        // } else if (selectedValue === 'name-desc') {
        //   sortedData = this.drivers.sort((a, b) => b.full_name.localeCompare(a.full_name));
      }

      this.updateTable(sortedData);
    }.bind(this));
  },
};

</script>

<template>
  <div class="drivers-wrapper">
    <!--    <router-link class="btn" to="/admin">Назад</router-link>-->
    <button class="btn" @click="back">Назад</button>
    <h2>Реестр зарегистированного транспорта:</h2>
    <select id="sort-select" class="my-select">
      <option value="default">Выберите сортировку</option>
      <option value="accidents-asc" class="my-option">По маркам</option>
      <option value="accidents-desc" class="my-option">По рег. номеру</option>
      <option value="id-asc" class="my-option">По типу</option>
    </select>
    <div class="table-container">
      <table id="drTable" class="table table-condensed table-striped table-bordered table-fixed-width">
        <thead>
        <tr>
          <th>Марка</th>
          <th>Модель</th>
          <th>Тип</th>
          <th>Регистрационный номер</th>
        </tr>
        </thead>
        <tbody>
        </tbody>
      </table>
    </div>

  </div>
</template>

<style scoped>

</style>s