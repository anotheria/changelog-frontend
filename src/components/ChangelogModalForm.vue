<template lang="html">
  <div class="modal-container">
    <div class="modal">
      <div class="modal__backdrop" @click="$emit('closeModal', false)"></div>
      <div class="modal__content">
        <form @submit.prevent="saveItem" class="modal__form">
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
                  v-model.trim="formData.reason"
                  :class="{'modal__input--invalid': v$.formData.reason.$error}"
                  class="modal__input"
                  type="text"
              />
            </div>
          </div>
          <div class="modal__label">
            <span class="modal__label-text"> Message </span>
            <div class="modal__input-wrap">
              <input
                  v-model.trim="formData.message"
                  class="modal__input"
                  type="text"
              />
            </div>
          </div>
          <div class="modal__label">
            <span class="modal__label-text"> Author </span>
            <div class="modal__input-wrap">
              <input
                  v-model.trim="formData.author"
                  :class="{'modal__input--invalid': v$.formData.author.$error }"
                  class="modal__input"
                  type="text"
              />
            </div>
          </div>

          <div class="modal__label">
            <span class="modal__label-text"> Date </span>
            <Datepicker
                v-model="currentDate"
                :class="{'dp--invalid': v$.currentDate.$error}"
                :format="'dd/MM/yyyy HH:mm'"
            ></Datepicker>
          </div>

          <div class="modal__label">
            <span class="modal__label-text"> Type </span>
            <div class="modal__input-wrap">
              <v-select
                  v-model="formData.type"
                  :class="{'vs--invalid': v$.formData.type.$error }"
                  :options="filtersList.type"
              >
                
                <template #open-indicator="{ attributes }">
                  <span v-bind="attributes"><img src="@/style/icon/down.svg" alt=""></span>
                </template>
              </v-select>
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
              >
                <template #open-indicator="{ attributes }">
                  <span v-bind="attributes"><img src="@/style/icon/down.svg" alt=""></span>
                </template>
              </v-select>
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
import useVuelidate from '@vuelidate/core'
import {required} from '@vuelidate/validators'

export default {
  components: {
    Datepicker,
    vSelect,
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
  setup() {
    console.log('setup');
    return {
      v$: useVuelidate()
    }
  },
  data() {
    return {
      currentItemId: null,
      formData: {
        id: null,
        timestamp: new Date(),
        author: "",
        message: "",
        reason: "",
        tags: [],
        type: null,
      },
      currentDate: new Date(),
      attributes: {
        'ref': 'openIndicator',
        'role': 'presentation',
        'class': 'vs__open-indicator',
      }
    }
  },

  validations() {
    return {
      formData: {
        reason: {required},
        author: {required},
        type: {required},
      },
      currentDate: {required}
    }
  },

  methods: {
    saveItem() {
      if (this.v$.$invalid) {
        this.v$.$touch();
        return
      }

      this.formData.timestamp = this.currentDate.getTime();
      axios
          .post("api/changelog/save/", this.formData)
          .then(() => {
            this.$emit("updateList");
            this.$emit("closeModal", false);
          })
          .catch((error) => console.log(error));
    }
  },

  mounted() {
    this.formData = this.currentFormData;
    this.currentDate = new Date(this.currentFormData.timestamp);
  }
};
</script>

<style scoped lang="scss"></style>
