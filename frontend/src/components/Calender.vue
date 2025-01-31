<template>
    <div>
        <vue-tailwind-datepicker
            ref="myRef"
            :formatter="formatter"
            v-model="dateValue"
        />
    </div>
</template>

<script>
import { ref } from 'vue'
import VueTailwindDatepicker from 'vue-tailwind-datepicker'

export default {
    components: {
        VueTailwindDatepicker
    },
    setup() {
        const myRef = ref(null);
        const dateValue = ref([]);
        const formatter = ref({
            date: 'DD MMM YYYY',
            month: 'MMM'
        });

        return {
            myRef,
            dateValue,
            formatter
        };
    }
};
</script>