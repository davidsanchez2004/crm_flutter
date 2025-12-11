# 📚 Guía: Configuración de Repositorio GitHub

## Paso 1: Crear Repositorio en GitHub

1. **Ir a GitHub.com**
   - Si no tienes cuenta, crear una
   - https://github.com/signup

2. **Crear nuevo repositorio**
   - Click en "+" → "New repository"
   - Nombre: `marketmove-crm`
   - Descripción: "Sistema de gestión integral para pequeños negocios - Flutter + Supabase"
   - Tipo: Public (para mostrar profesionalismo)
   - NO inicializar con README (ya tenemos uno)
   - Click "Create repository"

---

## Paso 2: Configurar Git Localmente

```bash
# 1. Abrirse en la carpeta del proyecto
cd c:\Users\David\Desktop\crm_flutter

# 2. Inicializar repositorio (si no está)
git init

# 3. Agregar archivo remoto
git remote add origin https://github.com/tu-usuario/marketmove-crm.git

# 4. Renombrar rama a main (estándar moderno)
git branch -M main

# 5. Agregar todos los archivos
git add .

# 6. Primer commit
git commit -m "Initial commit: MarketMove CRM v1.0.0

- Complete Flutter application with Supabase backend
- All features implemented and tested
- Full documentation included
- Ready for production deployment"

# 7. Subir a GitHub
git push -u origin main
```

---

## Paso 3: Configuración Post-Upload

### Agregar Topics
En GitHub, ir a Settings → About
Agregar topics:
- `flutter`
- `crm`
- `supabase`
- `dart`
- `business-management`
- `inventory-system`

### Configurar Descripción
Descripción corta: "CRM app for small business management"

### Agregar Licencia
- Settings → License
- Elegir MIT License

---

## Paso 4: Proteger la Rama Main

**Settings → Branches → Add rule**

- Branch name pattern: `main`
- ✅ Require pull request reviews (1)
- ✅ Require status checks to pass
- ✅ Include administrators

---

## Paso 5: Configurar Secrets para CI/CD (Futuro)

Si implementas CI/CD:
- Settings → Secrets and variables → Actions
- Agregar `SUPABASE_URL`
- Agregar `SUPABASE_ANON_KEY`

---

## ✅ Checklist Final

- [ ] Repositorio creado en GitHub
- [ ] `.gitignore` configurado
- [ ] Primer commit realizado
- [ ] Push a main exitoso
- [ ] Topics agregados
- [ ] Descripción del proyecto actualizada
- [ ] Licencia agregada
- [ ] Rama main protegida
- [ ] README visible en GitHub

---

## 🔗 Enlaces Útiles

- Repositorio: https://github.com/tu-usuario/marketmove-crm
- Issues: https://github.com/tu-usuario/marketmove-crm/issues
- Discussions: https://github.com/tu-usuario/marketmove-crm/discussions
- Projects: https://github.com/tu-usuario/marketmove-crm/projects

---

## 💡 Próximos Pasos

Después de subir a GitHub:

1. **Crear GitHub Pages** (opcional)
   - Para documentación del proyecto

2. **Configurar GitHub Actions** (opcional)
   - Para testing automático
   - Para build automático

3. **Crear Releases** (después de cada versión)
   - GitHub → Releases → New Release
   - Versión semántica (v1.0.0, v1.1.0, etc.)

---

**Fecha:** 11 de Diciembre, 2025  
**Estado:** Listo para publicar
