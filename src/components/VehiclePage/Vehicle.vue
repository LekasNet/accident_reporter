<script>
import './DriversPage.css';
export default {
  name: 'VehiclePage',
  methods:{
    back() {
      this.$router.push('/admin')
    },
  },
  mounted() {
    const data = [
      { id: 1, firstName: 'Иван', lastName: 'Иванов', middleName: 'Иванович', age: 30, accidents: 2 },
      { id: 2, firstName: 'Петр', lastName: 'Петров', middleName: 'Петрович', age: 40, accidents: 4 },
      { id: 3, firstName: 'Анна', lastName: 'Сидорова', middleName: 'Сергеевна', age: 25, accidents: 1 },
      // ...
    ];


    function updateTable(data) {
      // Получение элемента таблицы
      const table = document.getElementById('drTable');

      // Удаление всех строк из таблицы, кроме заголовка
      // const headerRow = table.querySelector('thead tr');
      const tbody = table.querySelector('tbody');
      tbody.innerHTML = '';

      // Добавление новых строк в таблицу
      data.forEach(item => {
        // Создание строки
        const row = document.createElement('tr');

        // Создание ячеек
        const idCell = document.createElement('td');
        idCell.textContent = item.id;
        const firstNameCell = document.createElement('td');
        firstNameCell.textContent = item.firstName;
        const lastNameCell = document.createElement('td');
        lastNameCell.textContent = item.lastName;
        const middleNameCell = document.createElement('td');
        middleNameCell.textContent = item.middleName;
        const ageCell = document.createElement('td');
        ageCell.textContent = item.age;
        const accidentsCell = document.createElement('td');
        accidentsCell.textContent = item.accidents;

        // Добавление ячеек в строку

        row.appendChild(lastNameCell);
        row.appendChild(firstNameCell);
        row.appendChild(middleNameCell);
        row.appendChild(ageCell);
        row.appendChild(accidentsCell);

        // Добавление строки в таблицу
        tbody.appendChild(row);
      });
    }

    const sortSelect = document.getElementById('sort-select');

    sortSelect.addEventListener('change', function() {

      const selectedValue = sortSelect.value;

      let sortedData = [];
      if (selectedValue === 'accidents-asc') {
        sortedData = data.sort((a, b) => a.accidents - b.accidents);
      }else if (selectedValue === 'accidents-desc') {
        sortedData = data.sort((a, b) => b.accidents - a.accidents);
      } else if (selectedValue === 'id-asc') {
        sortedData = data.sort((a, b) => a.id - b.id);
      } else if (selectedValue === 'name-asc') {
        sortedData = data.sort((a, b) => a.firstName.localeCompare(b.firstName));
      } else if (selectedValue === 'name-desc') {
        sortedData = data.sort((a, b) => b.firstName.localeCompare(a.firstName));
      }

      updateTable(sortedData);
    });
  }
};

</script>

<template>
  <div class="drivers-wrapper">
    <!--    <router-link class="btn" to="/admin">Назад</router-link>-->
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
          <th>Фамилия</th>
          <th>Имя</th>
          <th>Отчество</th>
          <th>Возраст</th>
          <th>Кол-во ДТП</th>
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