<template>
  <div>
    <img :src="require(`@/assets/icons/${ComponentName}.svg`)" width="30px" height="30px" alt="user">
  </div>
</template>

<script>
export default {
  name: 'DynamicSvg',
  props: {
    name: {
      type: String,
      required: true
    }
  },
  computed: {
    ComponentName() {
      return (this.name);
    }
  }
};
</script>
