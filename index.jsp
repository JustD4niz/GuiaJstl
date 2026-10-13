<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="hoy" class="java.util.Date"/>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Guía JSTL · Ejercicios</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
<style>
  :root{
    --navy:#0a1f44; --navy-2:#123a8f; --blue:#1e5eff; --blue-2:#0d47d9;
    --sky:#38bdf8; --ice:#eef5ff; --line:#d6e4ff; --ink:#12274d; --muted:#5b6f95;
  }
  body{background:var(--ice); color:var(--ink); font-family:'Segoe UI',system-ui,-apple-system,sans-serif;}

  /* Navbar */
  .navbar{background:linear-gradient(90deg,var(--navy),var(--navy-2)); box-shadow:0 4px 18px rgba(10,31,68,.35);}
  .navbar-brand{font-size:1.5rem; color:#fff !important;}

  /* Hero */
  .hero{
    color:#fff; position:relative; overflow:hidden;
    background:
      radial-gradient(circle at 15% 20%, rgba(56,189,248,.45), transparent 40%),
      radial-gradient(circle at 85% 80%, rgba(30,94,255,.55), transparent 45%),
      linear-gradient(135deg,var(--navy) 0%, #0f2f7a 55%, var(--blue) 100%);
  }
  .hero .bg-icon{position:absolute; font-size:16rem; opacity:.06; right:-2rem; bottom:-4rem;}

  /* Cuadrícula de ejercicios */
  .ej-grid{display:grid; grid-template-columns:repeat(4, minmax(0,1fr)); gap:1.25rem;}
  @media (max-width:992px){.ej-grid{grid-template-columns:repeat(2, minmax(0,1fr));}}
  @media (max-width:576px){.ej-grid{grid-template-columns:1fr;}}
  .ej-card{width:100%; text-align:center; background:#fff; border:1px solid var(--line); border-radius:18px;
    box-shadow:0 8px 24px rgba(30,94,255,.07); padding:26px 16px; cursor:pointer; transition:.2s;
    display:flex; flex-direction:column; align-items:center; gap:10px; font-family:inherit; color:var(--ink);}
  .ej-card:hover{transform:translateY(-3px); border-color:#bcd1ff; box-shadow:0 16px 32px rgba(30,94,255,.18); background:#f8fbff;}
  .ej-card:focus-visible{outline:3px solid rgba(30,94,255,.4);}

  .ej-titles{display:flex; flex-direction:column;}
  .ej-name{font-weight:700; color:var(--navy); font-size:1.05rem;}
  .ej-icon{width:56px; height:56px; border-radius:16px; display:grid; place-items:center; color:#fff; font-size:1.5rem; flex-shrink:0;
    background:linear-gradient(135deg,var(--blue),var(--sky)); box-shadow:0 8px 18px rgba(30,94,255,.35);}
  .ej-num{font-size:.78rem; text-transform:uppercase; letter-spacing:.12em; color:var(--blue); font-weight:700;}
  .tag{font-family:Consolas,monospace; background:#dbe8ff; color:var(--blue-2); padding:3px 12px; border-radius:99px; font-size:.8rem; font-weight:600;}

  /* Modal */
  .ej-modal{border:0; border-radius:18px; overflow:hidden; box-shadow:0 30px 70px rgba(10,31,68,.45);}
  .ej-modal .modal-header{background:linear-gradient(90deg,var(--navy),var(--blue)); color:#fff; border:0;
    padding:16px 22px; gap:12px; align-items:center;}
  .ej-modal .modal-header .ej-icon{width:44px; height:44px; font-size:1.15rem; background:rgba(255,255,255,.16); box-shadow:none;}
  .ej-modal .modal-header .ej-num{color:#aecbff;}
  .ej-modal .modal-header .ej-name{color:#fff; font-size:1.1rem;}
  .ej-modal .modal-header .tag{background:rgba(255,255,255,.18); color:#fff;}
  .ej-modal .modal-body{padding:26px;}
  .ej-modal .btn-close{filter:invert(1) grayscale(1) brightness(1.8); opacity:.9;}

  /* Formularios y botones */
  .form-control, .form-select{border-radius:12px; border:1px solid #bcd1ff;}
  .form-control:focus, .form-select:focus{border-color:var(--blue); box-shadow:0 0 0 .2rem rgba(30,94,255,.18);}
  .form-label{font-weight:600; color:var(--navy); font-size:.9rem;}
  .btn-blue{background:linear-gradient(135deg,var(--blue),var(--blue-2)); color:#fff; border:0; border-radius:99px; padding:.5rem 1.4rem; font-weight:600;}
  .btn-blue:hover{filter:brightness(1.1); color:#fff;}
  .btn-outline-blue{border:1.5px solid var(--blue); color:var(--blue); border-radius:99px; background:#fff; font-weight:600;}
  .btn-outline-blue:hover{background:var(--blue); color:#fff;}

  /* Código (sin JS, con <details>) */
  details.code-details summary{display:inline-block; cursor:pointer; list-style:none;}
  details.code-details summary::-webkit-details-marker{display:none;}
  .btn-code{background:#e3eeff; color:var(--blue-2); border:0; border-radius:99px; font-size:.85rem; font-weight:600; padding:.35rem 1rem;}

  /* Resultados */
  .result{border-left:5px solid var(--blue); background:linear-gradient(90deg,#f1f6ff,#fff); border-radius:12px; padding:16px 18px; height:100%;}
  .result .label{font-size:.78rem; text-transform:uppercase; letter-spacing:.1em; color:var(--muted); font-weight:700;}
  .result .value{font-size:1.15rem; font-weight:700; color:var(--navy);}
  .placeholder-box{display:flex; align-items:center; gap:10px; color:var(--muted); font-size:.95rem;}
  .alert{border-radius:12px; border:0;}
  .alert-danger{background:#e8efff; color:#0a2a7a; border-left:5px solid #0a2a7a;}
  .alert-info{background:#dff3ff; color:#06456b; border-left:5px solid var(--sky);}
  .alert-success{background:#e0f2ff; color:#0b4a8a; border-left:5px solid var(--blue);}
  .alert-warning{background:#eaf1ff; color:#1b3b86; border-left:5px solid #6b8cff;}

  /* Código */
  pre.code{background:var(--navy); color:#cfe3ff; border-radius:14px; padding:18px; margin:14px 0 0; overflow:auto; font-size:.82rem; line-height:1.55;}

  /* Tablas */
  .tabla-azul{border-radius:14px; overflow:hidden; border:1px solid var(--line); margin:0;}
  .tabla-azul thead th{background:linear-gradient(90deg,var(--navy),var(--blue)); color:#fff; border:0;}
  .tabla-azul tbody tr:nth-child(even){background:#f1f6ff;}
  .nota{background:#dbe8ff; color:var(--blue-2); border-radius:99px; padding:2px 10px; font-size:.78rem; font-weight:700;}

  /* Tokens */
  .token-chip{display:inline-flex; align-items:center; gap:8px; background:#fff; border:1px solid #bcd1ff; border-radius:99px;
    padding:4px 14px 4px 5px; margin:4px; font-weight:600; color:var(--navy);}
  .token-chip span{background:var(--blue); color:#fff; width:24px; height:24px; border-radius:50%; display:grid; place-items:center; font-size:.75rem;}

  footer{background:linear-gradient(90deg,var(--navy),var(--navy-2)); color:#cfe0ff;}
</style>
</head>
<body id="top">

<!-- ===================== NAVBAR ===================== -->
<nav class="navbar navbar-dark sticky-top">
  <div class="container">
    <span class="navbar-brand fw-bold mb-0"><i class="fas fa-layer-group me-2"></i>JSTL</span>
  </div>
</nav>

<!-- ===================== HERO ===================== -->
<header class="hero text-center">
  <i class="fas fa-code bg-icon"></i>
  <div class="container py-5 position-relative">
    <h1 class="display-5 fw-bold mb-2">Guía JSTL</h1>
    <p class="lead mb-0 mx-auto" style="max-width:640px">Pulsa un ejercicio para abrirlo en una ventana.</p>
  </div>
</header>

<main class="container py-5">

  <!-- ============ Conexión a PostgreSQL (Neon) solo para el ejercicio 8 ============ -->
  <c:if test="${param.ejercicio == '8'}">
    <c:catch var="errorBD">
      <sql:setDataSource var="empleados"
                         driver="org.postgresql.Driver"
                         url="jdbc:postgresql://ep-wispy-sun-ax5cy37r-pooler.c-4.us-east-2.aws.neon.tech/neondb?sslmode=require&amp;channel_binding=require"
                         user="neondb_owner"
                         password="npg_3FI4MDKBLRGf"/>

      <sql:update dataSource="${empleados}">
        CREATE TABLE IF NOT EXISTS empleados (
          id SERIAL PRIMARY KEY,
          nombres VARCHAR(100) NOT NULL,
          apellido1 VARCHAR(100),
          apellido2 VARCHAR(100),
          edad INT
        )
      </sql:update>

      <c:if test="${not empty fn:trim(param.nombres)}">
        <sql:update dataSource="${empleados}" var="filasInsertadas">
          INSERT INTO empleados (nombres, apellido1, apellido2, edad) VALUES (?, ?, ?, CAST(? AS INTEGER))
          <sql:param value="${param.nombres}"/>
          <sql:param value="${param.apellido1}"/>
          <sql:param value="${param.apellido2}"/>
          <sql:param value="${empty param.edad ? 0 : param.edad}"/>
        </sql:update>
      </c:if>

      <sql:query var="resultado" dataSource="${empleados}">
        SELECT id, nombres, apellido1, apellido2, edad FROM empleados ORDER BY id
      </sql:query>
    </c:catch>
  </c:if>

  <!-- ===================== CUADRÍCULA DE EJERCICIOS ===================== -->
  <div class="ej-grid">

    <button type="button" class="ej-card" data-bs-toggle="modal" data-bs-target="#ej1">
      <span class="ej-icon"><i class="fas fa-terminal"></i></span>
      <span class="ej-titles">
        <span class="ej-num">Ejercicio 1</span>
        <span class="ej-name">Impresión con c:out</span>
      </span>
      <span class="tag">core</span>
    </button>

    <button type="button" class="ej-card" data-bs-toggle="modal" data-bs-target="#ej2">
      <span class="ej-icon"><i class="fas fa-save"></i></span>
      <span class="ej-titles">
        <span class="ej-num">Ejercicio 2</span>
        <span class="ej-name">Guardado con c:set</span>
      </span>
      <span class="tag">core</span>
    </button>

    <button type="button" class="ej-card" data-bs-toggle="modal" data-bs-target="#ej3">
      <span class="ej-icon"><i class="fas fa-code-branch"></i></span>
      <span class="ej-titles">
        <span class="ej-num">Ejercicio 3</span>
        <span class="ej-name">Condicional c:if</span>
      </span>
      <span class="tag">core</span>
    </button>

    <button type="button" class="ej-card" data-bs-toggle="modal" data-bs-target="#ej4">
      <span class="ej-icon"><i class="fas fa-random"></i></span>
      <span class="ej-titles">
        <span class="ej-num">Ejercicio 4</span>
        <span class="ej-name">c:choose</span>
      </span>
      <span class="tag">core</span>
    </button>

    <button type="button" class="ej-card" data-bs-toggle="modal" data-bs-target="#ej5">
      <span class="ej-icon"><i class="fas fa-bug"></i></span>
      <span class="ej-titles">
        <span class="ej-num">Ejercicio 5</span>
        <span class="ej-name">Excepciones c:catch</span>
      </span>
      <span class="tag">core</span>
    </button>

    <button type="button" class="ej-card" data-bs-toggle="modal" data-bs-target="#ej6">
      <span class="ej-icon"><i class="fas fa-redo-alt"></i></span>
      <span class="ej-titles">
        <span class="ej-num">Ejercicio 6</span>
        <span class="ej-name">Ciclo c:forEach</span>
      </span>
      <span class="tag">core</span>
    </button>

    <button type="button" class="ej-card" data-bs-toggle="modal" data-bs-target="#ej7">
      <span class="ej-icon"><i class="fas fa-cut"></i></span>
      <span class="ej-titles">
        <span class="ej-num">Ejercicio 7</span>
        <span class="ej-name">Ciclo c:forTokens</span>
      </span>
      <span class="tag">core</span>
    </button>

    <button type="button" class="ej-card" data-bs-toggle="modal" data-bs-target="#ej8">
      <span class="ej-icon"><i class="fas fa-database"></i></span>
      <span class="ej-titles">
        <span class="ej-num">Ejercicio 8</span>
        <span class="ej-name">Base de datos SQL</span>
      </span>
      <span class="tag">sql</span>
    </button>

  </div>
</main>

<!-- ===================== MODALES ===================== -->

<%-- EJERCICIO 1 · c:out --%>
<div class="modal fade" id="ej1" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
    <div class="modal-content ej-modal">
      <div class="modal-header">
        <span class="ej-icon"><i class="fas fa-terminal"></i></span>
        <span class="ej-titles me-auto">
          <span class="ej-num">Ejercicio 1</span>
          <span class="ej-name">Impresión con c:out</span>
        </span>
        <span class="tag d-none d-sm-inline">core</span>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>
      <div class="modal-body">
        <p class="text-muted">Muestra información en la página: imprime la expresión del atributo <code>value</code>. Equivale a <code>&lt;%= %&gt;</code>.</p>
        <div class="row g-3">
          <div class="col-md-6">
            <div class="result">
              <div class="label"><i class="fas fa-font me-1"></i>Cadena de caracteres</div>
              <div class="value"><c:out value="1+2+3"/></div>
            </div>
          </div>
          <div class="col-md-6">
            <div class="result">
              <div class="label"><i class="fas fa-calculator me-1"></i>Suma de valores (EL)</div>
              <div class="value"><c:out value="${1+2+3}"/></div>
            </div>
          </div>
        </div>
        <details class="code-details mt-3">
          <summary class="btn-code"><i class="fas fa-code me-1"></i>Ver código</summary>
          <pre class="code">&lt;%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %&gt;

&lt;c:out value="1+2+3"/&gt;        &lt;%-- imprime: 1+2+3 --%&gt;
&lt;c:out value="&#36;{1+2+3}"/&gt;    &lt;%-- imprime: 6 --%&gt;</pre>
        </details>
      </div>
    </div>
  </div>
</div>

<%-- EJERCICIO 2 · c:set --%>
<div class="modal fade" id="ej2" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
    <div class="modal-content ej-modal">
      <div class="modal-header">
        <span class="ej-icon"><i class="fas fa-save"></i></span>
        <span class="ej-titles me-auto">
          <span class="ej-num">Ejercicio 2</span>
          <span class="ej-name">Guardado con c:set</span>
        </span>
        <span class="tag d-none d-sm-inline">core</span>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>
      <div class="modal-body">
        <p class="text-muted">Guarda un valor en una variable (<code>var</code>) de un ámbito (<code>scope</code>: page, request, session o application) y luego se imprime con <code>c:out</code>.</p>
        <div class="row g-4">
          <div class="col-lg-6">
            <form method="post" action="index.jsp?ejercicio=2">
              <input type="hidden" name="ejercicio" value="2">
              <input type="hidden" name="run" value="1">
              <div class="mb-3">
                <label class="form-label" for="e2_nombre"><i class="fas fa-user me-1"></i>Nombre</label>
                <input type="text" class="form-control" id="e2_nombre" name="nombre" placeholder="Nombre" value="${param.ejercicio == '2' ? fn:escapeXml(param.nombre) : ''}">
              </div>
              <div class="mb-3">
                <label class="form-label" for="e2_ap1"><i class="fas fa-id-card me-1"></i>Primer apellido</label>
                <input type="text" class="form-control" id="e2_ap1" name="apellido1" placeholder="Primer apellido" value="${param.ejercicio == '2' ? fn:escapeXml(param.apellido1) : ''}">
              </div>
              <div class="mb-3">
                <label class="form-label" for="e2_ap2"><i class="fas fa-id-card me-1"></i>Segundo apellido</label>
                <input type="text" class="form-control" id="e2_ap2" name="apellido2" placeholder="Segundo apellido" value="${param.ejercicio == '2' ? fn:escapeXml(param.apellido2) : ''}">
              </div>
              <button type="submit" class="btn btn-blue"><i class="fas fa-paper-plane me-1"></i>Enviar</button>
            </form>
          </div>
          <div class="col-lg-6">
            <div class="result">
              <c:choose>
                <c:when test="${not empty param.run}">
                  <c:set var="nombreCompleto" value="${param.nombre} ${param.apellido1} ${param.apellido2}" scope="request"/>
                  <div class="label mb-2"><i class="fas fa-print me-1"></i>Imprimiendo parámetros con JSTL</div>
                  <p class="mb-1">Nombre: <strong><c:out value="${param.nombre}"/></strong></p>
                  <p class="mb-1">Primer apellido: <strong><c:out value="${param.apellido1}"/></strong></p>
                  <p class="mb-3">Segundo apellido: <strong><c:out value="${param.apellido2}"/></strong></p>
                  <div class="label"><i class="fas fa-save me-1"></i>Variable guardada con c:set</div>
                  <div class="value"><c:out value="${nombreCompleto}"/></div>
                </c:when>
                <c:otherwise>
                  <div class="placeholder-box"><i class="fas fa-arrow-left"></i>Llena el formulario y envíalo para ver el resultado.</div>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </div>
        <details class="code-details mt-3">
          <summary class="btn-code"><i class="fas fa-code me-1"></i>Ver código</summary>
          <pre class="code">&lt;c:set var="nombreCompleto"
       value="&#36;{param.nombre} &#36;{param.apellido1} &#36;{param.apellido2}"
       scope="request"/&gt;

Nombre: &lt;c:out value="&#36;{param.nombre}"/&gt;
Completo: &lt;c:out value="&#36;{nombreCompleto}"/&gt;</pre>
        </details>
      </div>
    </div>
  </div>
</div>

<%-- EJERCICIO 3 · c:if --%>
<div class="modal fade" id="ej3" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
    <div class="modal-content ej-modal">
      <div class="modal-header">
        <span class="ej-icon"><i class="fas fa-code-branch"></i></span>
        <span class="ej-titles me-auto">
          <span class="ej-num">Ejercicio 3</span>
          <span class="ej-name">Condicional c:if</span>
        </span>
        <span class="tag d-none d-sm-inline">core</span>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>
      <div class="modal-body">
        <p class="text-muted">Procesa el cuerpo solo si la condición del atributo <code>test</code> es verdadera. Aquí valida que el nombre y el primer apellido no estén vacíos.</p>
        <div class="row g-4">
          <div class="col-lg-6">
            <form method="post" action="index.jsp?ejercicio=3">
              <input type="hidden" name="ejercicio" value="3">
              <input type="hidden" name="run" value="1">
              <div class="mb-3">
                <label class="form-label" for="e3_nombre"><i class="fas fa-user me-1"></i>Nombre</label>
                <input type="text" class="form-control" id="e3_nombre" name="nombre" placeholder="Nombre" value="${param.ejercicio == '3' ? fn:escapeXml(param.nombre) : ''}">
              </div>
              <div class="mb-3">
                <label class="form-label" for="e3_ap1"><i class="fas fa-id-card me-1"></i>Primer apellido</label>
                <input type="text" class="form-control" id="e3_ap1" name="apellido1" placeholder="Primer apellido" value="${param.ejercicio == '3' ? fn:escapeXml(param.apellido1) : ''}">
              </div>
              <div class="mb-3">
                <label class="form-label" for="e3_ap2"><i class="fas fa-id-card me-1"></i>Segundo apellido (opcional)</label>
                <input type="text" class="form-control" id="e3_ap2" name="apellido2" placeholder="Segundo apellido" value="${param.ejercicio == '3' ? fn:escapeXml(param.apellido2) : ''}">
              </div>
              <button type="submit" class="btn btn-blue"><i class="fas fa-check me-1"></i>Validar</button>
            </form>
          </div>
          <div class="col-lg-6">
            <div class="result">
              <c:choose>
                <c:when test="${not empty param.run}">
                  <c:if test="${empty fn:trim(param.nombre)}">
                    <div class="alert alert-danger"><i class="fas fa-times-circle me-1"></i><strong>¡Error!</strong> Nombre obligatorio</div>
                  </c:if>
                  <c:if test="${empty fn:trim(param.apellido1)}">
                    <div class="alert alert-danger"><i class="fas fa-times-circle me-1"></i><strong>¡Error!</strong> Primer apellido obligatorio</div>
                  </c:if>
                  <c:if test="${not empty fn:trim(param.nombre) and not empty fn:trim(param.apellido1)}">
                    <div class="alert alert-success mb-0">
                      <i class="fas fa-check-circle me-1"></i><strong>Datos correctos.</strong><br>
                      Nombre: <strong><c:out value="${param.nombre}"/></strong><br>
                      Primer apellido: <strong><c:out value="${param.apellido1}"/></strong><br>
                      Segundo apellido: <strong><c:out value="${param.apellido2}"/></strong>
                    </div>
                  </c:if>
                </c:when>
                <c:otherwise>
                  <div class="placeholder-box"><i class="fas fa-arrow-left"></i>Prueba dejando el nombre o el apellido vacío.</div>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </div>
        <details class="code-details mt-3">
          <summary class="btn-code"><i class="fas fa-code me-1"></i>Ver código</summary>
          <pre class="code">&lt;c:if test="&#36;{empty fn:trim(param.nombre)}"&gt;
  &lt;div class="alert alert-danger"&gt;Nombre obligatorio&lt;/div&gt;
&lt;/c:if&gt;

&lt;c:if test="&#36;{empty fn:trim(param.apellido1)}"&gt;
  &lt;div class="alert alert-danger"&gt;Primer apellido obligatorio&lt;/div&gt;
&lt;/c:if&gt;</pre>
        </details>
      </div>
    </div>
  </div>
</div>

<%-- EJERCICIO 4 · c:choose --%>
<div class="modal fade" id="ej4" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
    <div class="modal-content ej-modal">
      <div class="modal-header">
        <span class="ej-icon"><i class="fas fa-random"></i></span>
        <span class="ej-titles me-auto">
          <span class="ej-num">Ejercicio 4</span>
          <span class="ej-name">c:choose</span>
        </span>
        <span class="tag d-none d-sm-inline">core</span>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>
      <div class="modal-body">
        <p class="text-muted">Procesa condiciones múltiples: se ejecuta el primer <code>when</code> verdadero y, si ninguno se cumple, el <code>otherwise</code>.</p>
        <div class="row g-4">
          <div class="col-lg-6">
            <form method="post" action="index.jsp?ejercicio=4">
              <input type="hidden" name="ejercicio" value="4">
              <input type="hidden" name="run" value="1">
              <label class="form-label" for="e4_leng"><i class="fas fa-laptop-code me-1"></i>¿Cuál es tu lenguaje de programación favorito?</label>
              <select class="form-select mb-3" id="e4_leng" name="lenguaje">
                <option value="">-- Seleccionar un lenguaje</option>
                <option value="Java" ${param.lenguaje == 'Java' ? 'selected' : ''}>Java</option>
                <option value="C++" ${param.lenguaje == 'C++' ? 'selected' : ''}>C++</option>
                <option value="Perl" ${param.lenguaje == 'Perl' ? 'selected' : ''}>Perl</option>
              </select>
              <button type="submit" class="btn btn-blue"><i class="fas fa-paper-plane me-1"></i>Enviar</button>
            </form>
          </div>
          <div class="col-lg-6">
            <div class="result">
              <c:choose>
                <c:when test="${not empty param.run}">
                  <div class="label mb-2"><i class="fas fa-flag-checkered me-1"></i>Resultado</div>
                  <div class="value">
                    <c:choose>
                      <c:when test="${param.lenguaje == 'Java'}"><i class="fab fa-java me-2 text-primary"></i>El rey de los lenguajes orientados a objetos</c:when>
                      <c:when test="${param.lenguaje == 'C++'}"><i class="fas fa-graduation-cap me-2 text-primary"></i>Ideal para aprender</c:when>
                      <c:when test="${param.lenguaje == 'Perl'}"><i class="fas fa-scroll me-2 text-primary"></i>Lenguaje de scripting muy potente</c:when>
                      <c:otherwise><i class="fas fa-question-circle me-2 text-primary"></i>No se seleccionó ninguno</c:otherwise>
                    </c:choose>
                  </div>
                </c:when>
                <c:otherwise>
                  <div class="placeholder-box"><i class="fas fa-arrow-left"></i>Elige un lenguaje y envíalo.</div>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </div>
        <details class="code-details mt-3">
          <summary class="btn-code"><i class="fas fa-code me-1"></i>Ver código</summary>
          <pre class="code">&lt;c:choose&gt;
  &lt;c:when test="&#36;{param.lenguaje == 'Java'}"&gt;El rey de los lenguajes orientados a objetos&lt;/c:when&gt;
  &lt;c:when test="&#36;{param.lenguaje == 'C++'}"&gt;Ideal para aprender&lt;/c:when&gt;
  &lt;c:when test="&#36;{param.lenguaje == 'Perl'}"&gt;Lenguaje de scripting muy potente&lt;/c:when&gt;
  &lt;c:otherwise&gt;No se seleccionó ninguno&lt;/c:otherwise&gt;
&lt;/c:choose&gt;</pre>
        </details>
      </div>
    </div>
  </div>
</div>

<%-- EJERCICIO 5 · c:catch --%>
<div class="modal fade" id="ej5" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
    <div class="modal-content ej-modal">
      <div class="modal-header">
        <span class="ej-icon"><i class="fas fa-bug"></i></span>
        <span class="ej-titles me-auto">
          <span class="ej-num">Ejercicio 5</span>
          <span class="ej-name">Excepciones c:catch</span>
        </span>
        <span class="tag d-none d-sm-inline">core</span>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>
      <div class="modal-body">
        <p class="text-muted">Captura una excepción sin abortar la página: en <code>var</code> queda la excepción y, si no es nula, sabemos que hubo un error. Aquí se intenta convertir el parámetro a número entero.</p>
        <div class="d-flex flex-wrap gap-2 mb-3">
          <form method="post" action="index.jsp?ejercicio=5">
            <input type="hidden" name="ejercicio" value="5">
            <input type="hidden" name="run" value="1">
            <input type="hidden" name="parametro" value="prueba">
            <button type="submit" class="btn btn-outline-blue"><i class="fas fa-font me-1"></i>Enviar 'prueba'</button>
          </form>
          <form method="post" action="index.jsp?ejercicio=5">
            <input type="hidden" name="ejercicio" value="5">
            <input type="hidden" name="run" value="1">
            <input type="hidden" name="parametro" value="1234">
            <button type="submit" class="btn btn-blue"><i class="fas fa-hashtag me-1"></i>Enviar '1234'</button>
          </form>
          <form method="post" action="index.jsp?ejercicio=5">
            <input type="hidden" name="ejercicio" value="5">
            <input type="hidden" name="run" value="1">
            <button type="submit" class="btn btn-outline-blue"><i class="fas fa-ban me-1"></i>No enviar el parámetro</button>
          </form>
        </div>
        <div class="result">
          <c:choose>
            <c:when test="${not empty param.run}">
              <c:catch var="error05">
                <% int valorInt = Integer.parseInt(request.getParameter("parametro"));
                   request.setAttribute("valor05", valorInt); %>
              </c:catch>
              <c:if test="${not empty error05}">
                <div class="alert alert-danger mb-0"><i class="fas fa-exclamation-triangle me-1"></i><strong>Se produjo un error:</strong> <c:out value="${error05}"/></div>
              </c:if>
              <c:if test="${empty error05}">
                <div class="alert alert-info mb-0"><i class="fas fa-check-circle me-1"></i><strong>Valor recibido: <c:out value="${valor05}"/></strong></div>
              </c:if>
            </c:when>
            <c:otherwise>
              <div class="placeholder-box"><i class="fas fa-hand-pointer"></i>Pulsa uno de los tres botones.</div>
            </c:otherwise>
          </c:choose>
        </div>
        <details class="code-details mt-3">
          <summary class="btn-code"><i class="fas fa-code me-1"></i>Ver código</summary>
          <pre class="code">&lt;c:catch var="error05"&gt;
  &lt;% int valorInt = Integer.parseInt(request.getParameter("parametro"));
     request.setAttribute("valor05", valorInt); %&gt;
&lt;/c:catch&gt;

&lt;c:if test="&#36;{not empty error05}"&gt;
  Se produjo un error: &lt;c:out value="&#36;{error05}"/&gt;
&lt;/c:if&gt;
&lt;c:if test="&#36;{empty error05}"&gt;
  Valor recibido: &lt;c:out value="&#36;{valor05}"/&gt;
&lt;/c:if&gt;</pre>
        </details>
      </div>
    </div>
  </div>
</div>

<%-- EJERCICIO 6 · c:forEach --%>
<div class="modal fade" id="ej6" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
    <div class="modal-content ej-modal">
      <div class="modal-header">
        <span class="ej-icon"><i class="fas fa-redo-alt"></i></span>
        <span class="ej-titles me-auto">
          <span class="ej-num">Ejercicio 6</span>
          <span class="ej-name">Ciclo c:forEach</span>
        </span>
        <span class="tag d-none d-sm-inline">core</span>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>
      <div class="modal-body">
        <p class="text-muted">Itera de 1 a 24 de 2 en 2. Con <code>varStatus</code> se detecta la primera iteración y la número 5.</p>
        <div class="table-responsive">
          <table class="table table-borderless align-middle tabla-azul">
            <thead>
              <tr><th>Iteración</th><th>Valor</th><th>Nota</th></tr>
            </thead>
            <tbody>
              <c:forEach begin="1" end="24" step="2" var="hora" varStatus="st">
                <tr>
                  <td><span class="tag">${st.count}</span></td>
                  <td><strong><c:out value="${hora}"/></strong></td>
                  <td>
                    <c:if test="${st.first}"><span class="nota"><i class="fas fa-flag me-1"></i>Estoy en uno</span></c:if>
                    <c:if test="${st.count == 5}"><span class="nota"><i class="fas fa-star me-1"></i>Estoy en la iteración número 5</span></c:if>
                    <c:if test="${st.last}"><span class="nota"><i class="fas fa-flag-checkered me-1"></i>Última</span></c:if>
                  </td>
                </tr>
              </c:forEach>
            </tbody>
          </table>
        </div>
        <details class="code-details mt-3">
          <summary class="btn-code"><i class="fas fa-code me-1"></i>Ver código</summary>
          <pre class="code">&lt;c:forEach begin="1" end="24" step="2" var="hora" varStatus="st"&gt;
  &lt;c:out value="&#36;{hora}"/&gt;
  &lt;c:if test="&#36;{st.first}"&gt;Estoy en uno&lt;/c:if&gt;
  &lt;c:if test="&#36;{st.count == 5}"&gt;Estoy en la iteración número 5&lt;/c:if&gt;
&lt;/c:forEach&gt;</pre>
        </details>
      </div>
    </div>
  </div>
</div>

<%-- EJERCICIO 7 · c:forTokens --%>
<div class="modal fade" id="ej7" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
    <div class="modal-content ej-modal">
      <div class="modal-header">
        <span class="ej-icon"><i class="fas fa-cut"></i></span>
        <span class="ej-titles me-auto">
          <span class="ej-num">Ejercicio 7</span>
          <span class="ej-name">Ciclo c:forTokens</span>
        </span>
        <span class="tag d-none d-sm-inline">core</span>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>
      <div class="modal-body">
        <p class="text-muted">Recorre un texto separándolo por un delimitador. Ejemplo: texto <code>rojo,azul,verde</code> con delimitador <code>,</code>.</p>
        <div class="row g-4">
          <div class="col-lg-6">
            <form method="post" action="index.jsp?ejercicio=7">
              <input type="hidden" name="ejercicio" value="7">
              <input type="hidden" name="run" value="1">
              <div class="mb-3">
                <label class="form-label" for="e7_texto"><i class="fas fa-align-left me-1"></i>Introduzca un texto con delimitador</label>
                <input type="text" class="form-control" id="e7_texto" name="delimText" placeholder="rojo,azul,verde" value="${param.ejercicio == '7' ? fn:escapeXml(param.delimText) : ''}">
              </div>
              <div class="mb-3">
                <label class="form-label" for="e7_delim"><i class="fas fa-grip-lines-vertical me-1"></i>Introduzca el delimitador</label>
                <input type="text" class="form-control" id="e7_delim" name="delim" placeholder="," value="${param.ejercicio == '7' ? fn:escapeXml(param.delim) : ''}">
              </div>
              <button type="submit" class="btn btn-blue"><i class="fas fa-cut me-1"></i>Tokenize</button>
            </form>
          </div>
          <div class="col-lg-6">
            <div class="result">
              <c:choose>
                <c:when test="${not empty param.run}">
                  <div class="label mb-2"><i class="fas fa-list-ol me-1"></i>Your tokens</div>
                  <c:forTokens items="${param.delimText}" delims="${param.delim}" var="miToken" varStatus="tk">
                    <span class="token-chip"><span>${tk.count}</span><c:out value="${miToken}"/></span>
                  </c:forTokens>
                </c:when>
                <c:otherwise>
                  <div class="placeholder-box"><i class="fas fa-arrow-left"></i>Escribe un texto y su delimitador.</div>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </div>
        <details class="code-details mt-3">
          <summary class="btn-code"><i class="fas fa-code me-1"></i>Ver código</summary>
          <pre class="code">&lt;c:forTokens items="&#36;{param.delimText}" delims="&#36;{param.delim}" var="miToken"&gt;
  &lt;p&gt;&lt;c:out value="&#36;{miToken}"/&gt;&lt;/p&gt;
&lt;/c:forTokens&gt;</pre>
        </details>
      </div>
    </div>
  </div>
</div>

<%-- EJERCICIO 8 · SQL --%>
<div class="modal fade" id="ej8" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
    <div class="modal-content ej-modal">
      <div class="modal-header">
        <span class="ej-icon"><i class="fas fa-database"></i></span>
        <span class="ej-titles me-auto">
          <span class="ej-num">Ejercicio 8</span>
          <span class="ej-name">Base de datos SQL</span>
        </span>
        <span class="tag d-none d-sm-inline">sql</span>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
      </div>
      <div class="modal-body">
        <p class="text-muted">Se conecta a PostgreSQL en <strong>Neon</strong> (base <code>neondb</code>, tabla <code>empleados</code>), inserta el registro del formulario con <code>sql:update</code> y lista toda la tabla con <code>sql:query</code> y <code>c:forEach</code>.</p>

        <c:if test="${not empty errorBD}">
          <div class="alert alert-warning d-flex gap-3 align-items-start">
            <i class="fas fa-plug fs-4 mt-1"></i>
            <div>
              <strong>No se pudo usar la base de datos.</strong> Revisa tu conexión a Internet, los datos de conexión de Neon (URL, usuario y contraseña),
              que exista la tabla <code>empleados</code> y que el conector de PostgreSQL esté en <code>WEB-INF/lib</code>.<br>
              <small class="text-muted"><c:out value="${errorBD}"/></small>
            </div>
          </div>
        </c:if>

        <div class="row g-4">
          <div class="col-lg-5">
            <form method="post" action="index.jsp?ejercicio=8">
              <input type="hidden" name="ejercicio" value="8">
              <div class="mb-3">
                <label class="form-label" for="e8_nombres"><i class="fas fa-user me-1"></i>Nombre</label>
                <input type="text" class="form-control" id="e8_nombres" name="nombres" placeholder="Nombre" required>
              </div>
              <div class="row g-3 mb-3">
                <div class="col-6">
                  <label class="form-label" for="e8_ap1"><i class="fas fa-id-card me-1"></i>Primer apellido</label>
                  <input type="text" class="form-control" id="e8_ap1" name="apellido1" placeholder="Primer apellido">
                </div>
                <div class="col-6">
                  <label class="form-label" for="e8_ap2"><i class="fas fa-id-card me-1"></i>Segundo apellido</label>
                  <input type="text" class="form-control" id="e8_ap2" name="apellido2" placeholder="Segundo apellido">
                </div>
              </div>
              <div class="mb-3">
                <label class="form-label" for="e8_edad"><i class="fas fa-birthday-cake me-1"></i>Edad</label>
                <input type="number" min="0" class="form-control" id="e8_edad" name="edad" placeholder="Edad">
              </div>
              <button type="submit" class="btn btn-blue"><i class="fas fa-user-plus me-1"></i>Guardar empleado</button>
            </form>

            <c:if test="${empty errorBD and filasInsertadas == 1}">
              <div class="alert alert-success mt-3 mb-0"><i class="fas fa-check-circle me-1"></i>Registro guardado correctamente.</div>
            </c:if>
          </div>

          <div class="col-lg-7">
            <c:if test="${empty errorBD}">
              <div class="d-flex justify-content-between align-items-center mb-2">
                <span class="label fw-bold text-muted small text-uppercase"><i class="fas fa-table me-1"></i>Empleados registrados</span>
                <span class="tag"><c:out value="${resultado.rowCount}"/> registros</span>
              </div>
              <div class="table-responsive">
                <table class="table table-borderless align-middle tabla-azul">
                  <thead>
                    <tr><th>Id</th><th>Nombre</th><th>Apellidos</th><th>Edad</th></tr>
                  </thead>
                  <tbody>
                    <c:forEach var="fila" items="${resultado.rows}">
                      <tr>
                        <td><c:out value="${fila.id}"/></td>
                        <td><c:out value="${fila.nombres}"/></td>
                        <td><c:out value="${fila.apellido1}"/> <c:out value="${fila.apellido2}"/></td>
                        <td><c:out value="${fila.edad}"/></td>
                      </tr>
                    </c:forEach>
                    <c:if test="${resultado.rowCount == 0}">
                      <tr><td colspan="4" class="text-center text-muted py-3">Aún no hay empleados registrados.</td></tr>
                    </c:if>
                  </tbody>
                </table>
              </div>
            </c:if>
          </div>
        </div>

        <details class="code-details mt-3">
          <summary class="btn-code"><i class="fas fa-code me-1"></i>Ver código</summary>
          <pre class="code">&lt;sql:setDataSource var="empleados"
                 driver="org.postgresql.Driver"
                 url="jdbc:postgresql://ep-wispy-sun-ax5cy37r-pooler.c-4.us-east-2.aws.neon.tech/neondb?sslmode=require&amp;channel_binding=require"
                 user="neondb_owner" password="***"/&gt;

&lt;sql:update dataSource="&#36;{empleados}"&gt;
  INSERT INTO empleados (nombres, apellido1, apellido2, edad) VALUES (?, ?, ?, CAST(? AS INTEGER))
  &lt;sql:param value="&#36;{param.nombres}"/&gt;
  &lt;sql:param value="&#36;{param.apellido1}"/&gt;
  &lt;sql:param value="&#36;{param.apellido2}"/&gt;
  &lt;sql:param value="&#36;{param.edad}"/&gt;
&lt;/sql:update&gt;

&lt;sql:query var="resultado" dataSource="&#36;{empleados}"&gt;
  SELECT * FROM empleados
&lt;/sql:query&gt;

&lt;c:forEach var="fila" items="&#36;{resultado.rows}"&gt;
  &lt;tr&gt;&lt;td&gt;&lt;c:out value="&#36;{fila.nombres}"/&gt;&lt;/td&gt;&lt;/tr&gt;
&lt;/c:forEach&gt;</pre>
        </details>
      </div>
    </div>
  </div>
</div>

<!-- ===================== FOOTER ===================== -->
<footer class="py-4 text-center">
  <div class="container">
    <p class="mb-0"><i class="fas fa-layer-group me-2"></i><strong>Guía JSTL</strong> · <fmt:formatDate value="${hoy}" pattern="yyyy"/></p>
  </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  document.addEventListener('DOMContentLoaded', function () {
    var ej = new URLSearchParams(window.location.search).get('ejercicio');
    if (ej) {
      var el = document.getElementById('ej' + ej);
      if (el) { new bootstrap.Modal(el).show(); }
    }
  });
</script>
</body>
</html>
