<template lang="html">
  <div class="modal-container">
    <div class="modal">
      <div class="modal__backdrop" @click="$emit('closeModal', false)"></div>
      <div class="modal__content">
        <form @submit.prevent="saveItem()" class="modal__form">
          <button
            type="button"
            class="modal__btn-close"
            @click="$emit('closeModal', false)"
          >
            <img src="@/style/icon/close.svg" alt=""/>
          </button>
          <div class="modal__label">
            <span class="modal__label-text"> Reason </span>
            <div class="modal__input-wrap">
              <input
                v-model="formData.reason"
                class="modal__input"
                type="text"
              />
            </div>
          </div>
          <div class="modal__label">
            <span class="modal__label-text"> Message </span>
            <div class="modal__input-wrap">
              <input
                v-model="formData.message"
                class="modal__input"
                type="text"
              />
            </div>
          </div>
          <div class="modal__label">
            <span class="modal__label-text"> Author </span>
            <div class="modal__input-wrap">
              <input
                v-model="formData.author"
                class="modal__input"
                type="text"
              />
            </div>
          </div>

          <div class="modal__label">
            <span class="modal__label-text"> Date </span>
            <Datepicker
              v-model="currentDate"
              :format="'dd/MM/yyyy HH:mm'"
            ></Datepicker>
          </div>

          <div class="modal__label">
            <span class="modal__label-text"> Type </span>
            <div class="modal__input-wrap">
              <v-select
                v-model="formData.type"
                :options="filtersList.type"
              ></v-select>
            </div>
          </div>
          <div class="modal__label">
            <span class="modal__label-text"> Tags </span>
            <div class="modal__input-wrap">
              <v-select
                ref="select"
                v-model="formData.tags"
                :options="filtersList.tags"
                taggable
                multiple
              ></v-select>
            </div>
          </div>

          <div class="modal__btns">
            <button class="modal__btn btn">Save</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script lang="js">
  import axios from "axios";

  import Datepicker from "@vuepic/vue-datepicker";
  import "@vuepic/vue-datepicker/dist/main.css";

  import vSelect from 'vue-select'
  import "vue-select/dist/vue-select.css";

  export default {
    components: {
      Datepicker,
      vSelect
    },
    props: {
      filtersList: {
        type: Object,
        required: true
      },
      currentFormData: {
        type: Object
      }
    },
    data: () => ({
      currentItemId: null,
      formData: {},
      currentDate: new Date()
    }),

    methods: {
      saveItem() {
        this.formData.timestamp = this.currentDate.getTime();
        axios
          .post("api/changelog/save/", this.formData)
          .then(() => {
            this.$emit("updateList");
            this.$emit("closeModal", false);
          })
          .catch((error) => console.log(error));
      },
    },

    mounted() {
      this.formData = this.currentFormData;
      this.currentDate = new Date(this.currentFormData.timestamp);
    }
  };
</script>

<style scoped lang="scss"></style>
