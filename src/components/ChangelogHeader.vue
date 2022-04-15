<template lang="html">

  <header class="header">
    <div class="container">
      <div class="header__inner">
        <div class="header__logo">Anotheria changelog</div>
        <form class="header__search search" @submit.prevent>
          <input
            @change="getSearchResult"
            class="search__input"
            type="text"
            placeholder="Search"
            v-model="inputValue"
          />
          <button :type="inputValue ? 'reset' : 'submit'"
                  :class="{
                    'search__btn--close': inputValue,
                    'search__btn--search': !inputValue,
                   }"
                  @click.prevent="cleanInput"
                  class="search__btn"
          >
          </button>
        </form>
      </div>
    </div>
  </header>

</template>

<script lang="js">
  import axios from "axios";

  export default {
    name: 'changelog-header',
    props: {
      changelogList: {
        type: Array,
        required: true
      },
      loader: {
        type: Boolean
      }
    },
    mounted() {

    },
    data() {
      return {
        inputValue: ''
      }
    },
    methods: {
      async getSearchResult(event) {
        this.$emit('update:loader', true);
        let searchRequest = event.target.value;
        axios
          .get(`api/changelog/entries/${searchRequest}`)
          .then((response) => {
            this.$emit('update:changelogList', response.data.results.entries);
            this.$emit('update:loader', false);
          })
          .catch((error) => console.log(`getSearchResult() error : ${error}`));
      },

      cleanInput(event) {
        this.inputValue = '';
        this.getSearchResult(event);
      }
    },
    computed: {}
  }


</script>

<style scoped lang="scss">
</style>
