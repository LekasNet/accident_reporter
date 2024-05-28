<template>
  <div class="drivers-wrapper">
    <button class="btn" @click="back">Назад</button>
    <h2>Список водителей:</h2>
    <select id="sort-select" class="my-select">
      <option value="default">Выберите сортировку</option>
      <option value="accidents-asc" class="my-option">По возрастанию количества ДТП</option>
      <option value="accidents-desc" class="my-option">По убыванию количества ДТП</option>
      <option value="id-asc" class="my-option">По id водителя</option>
      <option value="name-asc" class="my-option">По алфавиту (имя)</option>
      <option value="name-desc" class="my-option">По алфавиту (имя, обратный порядок)</option>
    </select>
    <div class="table-container">
      <table id="drTable" class="table table-condensed table-striped table-bordered table-fixed-width">
        <thead>
        <tr>
          <th>ФИО</th>
          <th>Телефон</th>
          <th>Опыт вождения</th>
          <th>Лицензия</th>
        </tr>
        </thead>
        <tbody>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script>
import './DriversPage.css';

export default {
  name: 'DriversPage',
  data() {
    return {
      drivers: [],
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
        const response = await fetch('https://accident-reporter.onrender.com/policeDepartment/drivers', request);
        const jsonResponse = await response.json();
        console.log(jsonResponse.data);
        if (Array.isArray(jsonResponse.data)) {
          this.drivers = jsonResponse.data;
          this.updateTable(this.drivers);
        } else {
          console.error('Ошибка: сервер не возвращает массив данных');
        }
      } catch (error) {
        console.error('Ошибка получения данных о водителях:', error);
      }
    },
    updateTable(data) {
      const table = document.getElementById('drTable');
      const tbody = table.querySelector('tbody');
      tbody.innerHTML = '';

      data.forEach(driver => {
        const row = document.createElement('tr');
        const fullNameCell = document.createElement('td');
        fullNameCell.textContent = driver.full_name;
        const phoneCell = document.createElement('td');
        phoneCell.textContent = driver.phone;
        const experienceCell = document.createElement('td');
        experienceCell.textContent = driver.driving_experience;
        const licenceCell = document.createElement('td');
        licenceCell.textContent = driver.driver_license;

        row.appendChild(fullNameCell);
        row.appendChild(phoneCell);
        row.appendChild(experienceCell);
        row.appendChild(licenceCell);
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